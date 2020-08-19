// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import UIKit
import WebKit

public final class MonacoEditorView: UIView {
  public var configuration: MonacoEditorConfiguration

  private var isLoaded = false
  private var navigationHandler: NavigationHandler!
  private var uiHandler: UIHandler!
  private weak var webView: WKWebView!

  public init(frame: CGRect, configuration: MonacoEditorConfiguration) {
    self.configuration = configuration

    super.init(frame: frame)

    setupWebView()
    loadEditor()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  public func updateConfiguration(_ configuration: MonacoEditorConfiguration) {
    self.configuration = configuration
    guard isLoaded else {
      return
    }

    do {
      let options = StandaloneEditorConstructionOptions(configuration)
      let jsonData = try JSONEncoder().encode(options)
      let json = String(data: jsonData, encoding: .utf8)!
      let javascript =
"""
(function() {
  let options = JSON.parse('\(json)');
  editor.updateOptions(options);
  return true;
})();
"""
      evaluateJavascript(javascript)
    } catch {
      print("ERROR: \(error)")
    }
  }
}

private extension MonacoEditorView {
  func createEditor() {
    do {
      let options = StandaloneEditorConstructionOptions(configuration)
      let jsonData = try JSONEncoder().encode(options)
      let json = String(data: jsonData, encoding: .utf8)!
      let javascript =
"""
(function() {
  let options = JSON.parse('\(json)');
  editor.create(options);
  return true;
})();
"""
      evaluateJavascript(javascript)
    } catch {
      print("ERROR: \(error)")
    }
  }

  func loadEditor() {
    let url = URL(string: "monacoeditor://editor")!
    let request = URLRequest(
      url: url,
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
      timeoutInterval: 10.0
    )
    webView.load(request)
  }

  func setupWebView() {
    navigationHandler = NavigationHandler()
    navigationHandler.ready = {
      self.isLoaded = true
      self.createEditor()
    }

    uiHandler = UIHandler()

    let configuration = WKWebViewConfiguration()
    configuration.setURLSchemeHandler(
      MonacoEditorURLSchemeHandler(),
      forURLScheme: "monacoeditor"
    )

    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = navigationHandler
    webView.uiDelegate = uiHandler
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.keyboardDisplayRequiresUserAction = false
    addSubview(webView)
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: topAnchor),
      webView.leadingAnchor.constraint(equalTo: leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    self.webView = webView
  }
}

private extension MonacoEditorView {
  func evaluateJavascript(_ javascript: String) {
    if #available(iOS 14.0, *) {
      webView.evaluateJavaScript(javascript, in: nil, in: WKContentWorld.page) { result in
        guard case .failure(let error) = result else {
          return
        }

        print("ERROR: \(error)")
      }
    } else {
      webView.evaluateJavaScript(javascript) { (result, error) in
        guard let error = error else {
          return
        }

        print("ERROR: \(error)")
      }
    }
  }
}
