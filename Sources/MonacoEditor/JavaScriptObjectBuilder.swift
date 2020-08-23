// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import Foundation

struct JavaScriptObjectBuilder {
  private let falseString = "false"
  private let trueString = "true"

  private var javascript: String = "{"
  private var isFirst: Bool = true

  mutating func append(key: String, value: Bool?) {
    guard let value = value else {
      return
    }

    append(key: key, javascript: value ? trueString : falseString)
  }

  mutating func append(key: String, value: Int?) {
    guard let value = value else {
      return
    }

    append(key: key, javascript: String(format: "%d", value))
  }

  mutating func append(key: String, value: Float?) {
    guard let value = value else {
      return
    }

    append(key: key, javascript: String(format: "%f", value))
  }

  mutating func append(key: String, value: [MonacoEditorKeyBinding]?) {
    guard let keybindings = value else {
      return
    }

    var array = "["
    var isFirst = true
    for keybinding in keybindings {
      if isFirst {
        isFirst = false
      } else {
        array.append(",")
      }

      array.append(keybinding.keybinding)
    }

    array.append("]")
    append(key: key, javascript: array)
  }
  
  mutating func append(key: String, value: String?) {
    guard let value = value else {
      return
    }

    appendPrefix()
    javascript.append(String(format: "%@:\'%@\'", key, value))
  }

  mutating func append(key: String, javascript: String?) {
    guard let javascript = javascript else {
      return
    }

    appendPrefix()
    self.javascript.append(String(format: "%@:%@", key, javascript))
  }

  mutating func append(
    key: String,
    value: MonacoEditorConfiguration.LineNumbersType?
  ) {
    guard let value = value else {
      return
    }

    switch value {
    case .function(let javascript): append(key: key, javascript: javascript)
    default: append(key: key, value: value.javascript)
    }
  }

  func build() -> String {
    return javascript.appending("}")
  }

  private mutating func appendPrefix() {
    guard !isFirst else {
      isFirst = false
      return
    }

    javascript.append(",")
  }
}
