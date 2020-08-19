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

import Foundation
import WebKit

final class UIHandler: NSObject,WKUIDelegate {
  func webViewDidClose(_ webView: WKWebView) {
    print(#function)
  }

  func webView(
    _ webView: WKWebView,
    contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo
  ) {
    print(#function)
  }

  func webView(
    _ webView: WKWebView,
    contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo
  ) {
    print(#function)
  }

  func webView(
    _ webView: WKWebView,
    contextMenuForElement elementInfo: WKContextMenuElementInfo,
    willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating
  ) {
    print(#function)
  }

  func webView(
    _ webView: WKWebView,
    contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo,
    completionHandler: @escaping (UIContextMenuConfiguration?) -> Void
  ) {
    print(#function)
    completionHandler(nil)
  }

  func webView(
    _ webView: WKWebView,
    runJavaScriptAlertPanelWithMessage message: String,
    initiatedByFrame frame: WKFrameInfo,
    completionHandler: @escaping () -> Void)
  {
    print(#function)
    completionHandler()
  }

  func webView(
    _ webView: WKWebView,
    runJavaScriptConfirmPanelWithMessage message: String,
    initiatedByFrame frame: WKFrameInfo,
    completionHandler: @escaping (Bool) -> Void
  ) {
    print(#function)
    completionHandler(true)
  }

  func webView(
    _ webView: WKWebView,
    createWebViewWith configuration: WKWebViewConfiguration,
    for navigationAction: WKNavigationAction,
    windowFeatures: WKWindowFeatures
  ) -> WKWebView? {
    print(#function)
    return nil
  }

  func webView(
    _ webView: WKWebView,
    runJavaScriptTextInputPanelWithPrompt prompt: String,
    defaultText: String?,
    initiatedByFrame frame: WKFrameInfo,
    completionHandler: @escaping (String?) -> Void
  ) {
    print(#function)
    completionHandler(nil)
  }

  func webView(
    _ webView: WKWebView,
    commitPreviewingViewController previewingViewController: UIViewController
  ) {
    print(#function)
  }

  func webView(
    _ webView: WKWebView,
    shouldPreviewElement elementInfo: WKPreviewElementInfo
  ) -> Bool {
    print(#function)
    return true
  }

  func webView(
    _ webView: WKWebView,
    previewingViewControllerForElement elementInfo: WKPreviewElementInfo,
    defaultActions previewActions: [WKPreviewActionItem]
  ) -> UIViewController? {
    print(#function)
    return nil
  }
}
