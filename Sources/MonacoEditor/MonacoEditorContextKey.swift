// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import Foundation
import WebKit

public final class MonacoEditorContextKey<T: MonacoEditorContextKeyValue> {
  private let key: String

  private weak var webView: WKWebView?

  init(webView: WKWebView, key: String) {
    self.key = key
    self.webView = webView
  }

  func get(completionHandler: @escaping (Result<T?, Error>) -> Void) {
    guard let webView = webView else {
      completionHandler(.success(nil))
      return
    }

    let javascript =
"""
(function() {
  return editor.getContextKey('\(key)');
})();
"""
    if #available(iOS 14.0, *) {
      webView.evaluateJavaScript(javascript, in: nil, in: WKContentWorld.page) {
        switch $0 {
        case .success(let result): completionHandler(.success(result as? T))
        case .failure(let error): completionHandler(.failure(error))
        }
      }
    } else {
      webView.evaluateJavaScript(javascript) { (result, error) in
        if let error = error {
          completionHandler(.failure(error))
          return
        }

        completionHandler(.success(result as? T))
      }
    }
  }

  func reset() {
    guard let webView = webView else {
      return
    }

    let javascript =
"""
(function() {
  editor.resetContextKey('\(key)');
  return true;
})();
"""
    if #available(iOS 14.0, *) {
      webView.evaluateJavaScript(javascript, in: nil, in: WKContentWorld.page)
    } else {
      webView.evaluateJavaScript(javascript);
    }
  }

  func set(_ value: T) {
    guard let webView = webView else {
      return
    }

    let javascript =
"""
(function() {
  editor.setContextKey('\(key)', \(value.javascript));
  return true;
})();
"""
    if #available(iOS 14.0, *) {
      webView.evaluateJavaScript(javascript, in: nil, in: WKContentWorld.page)
    } else {
      webView.evaluateJavaScript(javascript);
    }
  }
}

public protocol MonacoEditorContextKeyValue {
  var javascript: String { get }
}

extension Bool: MonacoEditorContextKeyValue {
  public var javascript: String {
    return self ? "true" : "false"
  }
}

extension String: MonacoEditorContextKeyValue {
  public var javascript: String {
    return "'\(self)'"
  }
}

extension Int: MonacoEditorContextKeyValue {
  public var javascript: String {
    return String(format: "%d", self)
  }
}

extension Float: MonacoEditorContextKeyValue {
  public var javascript: String {
    return String(format:"%f", self)
  }
}
