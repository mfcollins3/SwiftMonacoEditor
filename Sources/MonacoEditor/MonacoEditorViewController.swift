// Copyright 2020 Michael F. Collins, III
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Combine
import Foundation
import UIKit
import WebKit

open class MonacoEditorViewController: UIViewController {
  private var keyboardGuide: UILayoutGuide!
  private var heightConstraint: NSLayoutConstraint!
  private var isKeyboardVisible = false
  private var navigationHandler: NavigationHandler!
  private var subscriptions = Set<AnyCancellable>()
  private var uiHandler: UIHandler!
  private weak var webView: WKWebView!

  open override func viewDidLoad() {
    super.viewDidLoad()

    setupWebView()
    loadEditor()
  }

  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    subscribeToKeyboardDidShowNotification()
    subscribeToKeyboardDidHideNotification()
    subscribeToKeyboardDidChangeFrameNotification()
    focusEditor()
  }

  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    subscriptions.forEach { $0.cancel() }
    subscriptions.removeAll()
  }
}

// MARK: - View controller initialization -

private extension MonacoEditorViewController {
  func loadEditor() {
    let url = URL(string: "monacoeditor//editor")!
    let request = URLRequest(
      url: url,
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
      timeoutInterval: 10.0
    )
    webView.load(request)
  }

  func setupWebView() {
    keyboardGuide = UILayoutGuide()
    view.addLayoutGuide(keyboardGuide)
    keyboardGuide.bottomAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.bottomAnchor
    )
    .isActive = true

    heightConstraint = keyboardGuide.heightAnchor.constraint(equalToConstant: 0)
    heightConstraint.isActive = true

    navigationHandler = NavigationHandler()
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
    view.addSubview(webView)
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor
      ),
      webView.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor
      ),
      webView.bottomAnchor.constraint(equalTo: keyboardGuide.topAnchor)
    ])

    self.webView = webView
  }
}

// MARK: - Keyboard Handling -

private extension MonacoEditorViewController {
  func subscribeToKeyboardDidChangeFrameNotification() {
    NotificationCenter.default
      .publisher(for: UIView.keyboardDidChangeFrameNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (notification) in
        guard let self = self,
              self.isKeyboardVisible,
              let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                as? CGRect
        else {
          return
        }

        self.updateViewForKeyboardFrame(frame)
      }
      .store(in: &subscriptions)
  }

  func subscribeToKeyboardDidHideNotification() {
    NotificationCenter.default
      .publisher(for: UIView.keyboardDidHideNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (notification) in
        guard let self = self else {
          return
        }

        self.isKeyboardVisible = false
      }
      .store(in: &subscriptions)
  }

  func subscribeToKeyboardDidShowNotification() {
    NotificationCenter.default
      .publisher(for: UIView.keyboardDidShowNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (notification) in
        guard let self = self else {
          return
        }

        self.isKeyboardVisible = true
      }
      .store(in: &subscriptions)
  }

  func updateViewForKeyboardFrame(_ frame: CGRect) {
    guard isKeyboardVisible else {
      return
    }

    let convertedFrame =
      view.convert(frame, from: UIScreen.main.coordinateSpace)
    let intersectedKeyboardHeight =
      view.frame.intersection(convertedFrame).height
    UIView.animate(withDuration: 0.2) {
      self.heightConstraint.constant = intersectedKeyboardHeight
      self.view.layoutIfNeeded()
    }
  }
}

// MARK: - Editor interaction -

private extension MonacoEditorViewController {
  func focusEditor() {
    let javascript = "editor.focus();"
    if #available(iOS 14.0, *) {
      webView.evaluateJavaScript(
        javascript,
        in: nil,
        in: WKContentWorld.page
      )
    } else {
      webView.evaluateJavaScript(javascript)
    }
  }
}
