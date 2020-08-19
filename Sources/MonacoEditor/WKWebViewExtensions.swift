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

// See https://stackoverflow.com/questions/32449870/programmatically-focus-on-a-form-in-a-webview-wkwebview

import Foundation
import WebKit

typealias WebViewClosureType = @convention(c) (
  Any,
  Selector,
  UnsafeRawPointer,
  Bool,
  Bool,
  Bool,
  Any?
) -> Void

extension WKWebView {
  var keyboardDisplayRequiresUserAction: Bool? {
    get {
      return self.keyboardDisplayRequiresUserAction
    }
    set {
      self.setKeyboardRequiresUserInteraction(newValue ?? true)
    }
  }

  func setKeyboardRequiresUserInteraction(_ value: Bool) {
    guard let WKContentView = NSClassFromString("WKContentView") else {
      print("keyboardDisplayRequiresUserAction: cannot find the WKContentView class")
      return
    }

    let sel: Selector =
      sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:activityStateChanges:userObject:")
    guard let method = class_getInstanceMethod(WKContentView, sel) else {
      return
    }

    let originalImp = method_getImplementation(method)
    let original: WebViewClosureType =
      unsafeBitCast(originalImp, to: WebViewClosureType.self)
    let block: @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void =
      { (me, arg0, arg1, arg2, arg3, arg4) in
        original(me, sel, arg0, !value, arg2, arg3, arg4)
      }
    let imp = imp_implementationWithBlock(block)
    method_setImplementation(method, imp)
  }
}
