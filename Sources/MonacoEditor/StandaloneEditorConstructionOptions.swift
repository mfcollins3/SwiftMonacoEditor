// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import Foundation

struct StandaloneEditorConstructionOptions {
  let language: String?
  let lineNumbers: MonacoEditorConfiguration.LineNumbersType?
  let readOnly: Bool?
  let roundedSelection: Bool?
  let scrollBeyondLastLine: Bool?
  let theme: String?
  let value: String?
  let wordWrap: String?
  let wordWrapColumn: Int?
  let wordWrapMinified: Bool?
  let wrappingIndent: String?

  init(
    text: String? = nil,
    configuration: MonacoEditorConfiguration
  ) {
    language = configuration.language
    lineNumbers = configuration.lineNumbers
    readOnly = configuration.readOnly
    roundedSelection = configuration.roundedSelection
    scrollBeyondLastLine = configuration.scrollBeyondLastLine
    theme = configuration.theme
    value = text
    wordWrap = configuration.wordWrap?.rawValue
    wordWrapColumn = configuration.wordWrapColumn
    wordWrapMinified = configuration.wordWrapMinified
    wrappingIndent = configuration.wrappingIndent?.rawValue
  }

  var javascript: String {
    get {
      let encodedValue = value?.data(using: .utf8)?.base64EncodedString()
      var builder = JavaScriptObjectBuilder()
      builder.append(key: "language", value: language)
      builder.append(key: "lineNumbers", value: lineNumbers)
      builder.append(key: "readOnly", value: readOnly)
      builder.append(key: "roundedSelection", value: roundedSelection)
      builder.append(key: "scrollBeyondLastLine", value: scrollBeyondLastLine)
      builder.append(key: "theme", value: theme)
      builder.append(key: "value", value: encodedValue)
      builder.append(key: "wordWrap", value: wordWrap)
      builder.append(key: "wordWrapColumn", value: wordWrapColumn)
      builder.append(key: "wordWrapMinified", value: wordWrapMinified)
      builder.append(key: "wrappingIndent", value: wrappingIndent)
      return builder.build()
    }
  }
}
