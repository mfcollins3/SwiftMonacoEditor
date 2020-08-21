// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import UIKit
import WebKit

public final class MonacoEditorView: UIView {
  public let configuration: MonacoEditorConfiguration
  public let contentChanged: ((String) -> Void)?

  private var commandList = [MonacoEditorCommand]()
  private var commands = [String: () -> Void]()
  private var isLoaded = false
  private var navigationHandler: NavigationHandler!
  private var uiHandler: UIHandler!
  private weak var webView: WKWebView!

  var text: String {
    didSet {
      guard isLoaded else {
        return
      }
      
      let encodedText = text.data(using: .utf8)?.base64EncodedString() ?? ""
      let javascript =
"""
(function() {
  let text = atob('\(encodedText)');
  editor.setText(text);
  return true
})();
"""
      evaluateJavascript(javascript)
    }
  }

  public init(
    frame: CGRect,
    text: String? = nil,
    configuration: MonacoEditorConfiguration,
    contentChanged: ((String) -> Void)? = nil
  ) {
    self.configuration = configuration
    self.contentChanged = contentChanged
    self.text = text ?? ""

    super.init(frame: frame)

    setupWebView()
    loadEditor()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  public func addCommand(_ command: MonacoEditorCommand) {
    guard isLoaded else {
      commandList.append(command)
      return
    }

    addCommand(
      keyBinding: command.keyBinding,
      context: command.context,
      handler: command.command
    )
  }

  private func addCommand(
    keyBinding: MonacoEditorKeyBinding,
    context: String? = nil,
    handler: @escaping () -> Void
  ) {
    var modifier: String?
    var keyCode: String
    switch keyBinding {
    case .key(let value):
      modifier = nil
      keyCode = value.rawValue

    case .alt(let value):
      modifier = "monaco.KeyMod.Alt | "
      keyCode = value.rawValue

    case .ctrlCmd(let value):
      modifier = "monaco.KeyMod.CtrlCmd | "
      keyCode = value.rawValue

    case .shift(let value):
      modifier = "monaco.KeyMod.Shift | "
      keyCode = value.rawValue

    case .winCtrl(let value):
      modifier = "monaco.KeyMod.WinCtrl | "
      keyCode = value.rawValue
    }

    var contextString: String?
    if let context = context {
      contextString = ",\n\t\t\(context)"
    }

    let commandID = UUID().uuidString
    commands[commandID] = handler
    let javascript =
"""
(function() {
  editor.addCommand(function(monaco, editor) {
    editor.addCommand(
      \(modifier ?? "")monaco.KeyCode.\(keyCode),
      function() {
        window.webkit.messageHandlers.executeCommand.postMessage('\(commandID)');
      }\(contextString ?? "")
    );
  });
  return true;
})();
"""
    evaluateJavascript(javascript)
  }

  public func updateConfiguration() {
    guard isLoaded else {
      return
    }

    let options = StandaloneEditorConstructionOptions(
      configuration: configuration
    )
    let javascript =
"""
(function() {
  let options = \(options.javascript);
  if (options.value) {
    options.value = atob(options.value);
  }

  editor.updateOptions(options);
  return true;
})();
"""
    evaluateJavascript(javascript)
  }
}

private extension MonacoEditorView {
  func createEditor() {
    createMonacoEditor()
    addCommands()
  }

  func createMonacoEditor() {
    let options = StandaloneEditorConstructionOptions(
      text: text,
      configuration: configuration
    )
    let javascript =
"""
(function() {
  let options = \(options.javascript);
  if (options.value) {
    options.value = atob(options.value);
  }

  editor.create(options);
  return true;
})();
"""
    evaluateJavascript(javascript)
  }

  func addCommands() {
    for command in commandList {
      self.addCommand(
        keyBinding: command.keyBinding,
        context: command.context,
        handler: command.command
      )
    }

    commandList.removeAll()
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
    configuration.userContentController.add(
      UpdateTextScriptHandler(self),
      name: "updateText"
    )
    configuration.userContentController.add(
      ExecuteCommandScriptHandler(self),
      name: "executeCommand"
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

private extension MonacoEditorView {
  final class UpdateTextScriptHandler: NSObject, WKScriptMessageHandler {
    private let parent: MonacoEditorView

    init(_ parent: MonacoEditorView) {
      self.parent = parent
    }

    func userContentController(
      _ userContentController: WKUserContentController,
      didReceive message: WKScriptMessage
    ) {
      guard let encodedText = message.body as? String,
            let data = Data(base64Encoded: encodedText),
            let text = String(data: data, encoding: .utf8) else {
        fatalError("Unexpected message body")
      }

      parent.contentChanged?(text)
    }
  }
}

private extension MonacoEditorView {
  final class ExecuteCommandScriptHandler: NSObject, WKScriptMessageHandler {
    private let parent: MonacoEditorView

    init(_ parent: MonacoEditorView) {
      self.parent = parent
    }

    func userContentController(
      _ userContentController: WKUserContentController,
      didReceive message: WKScriptMessage
    ) {
      guard let commandID = message.body as? String,
            let command = parent.commands[commandID]
      else {
        fatalError("Unexpected message body")
      }

      command()
    }
  }
}
