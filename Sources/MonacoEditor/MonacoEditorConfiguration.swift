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

import SwiftUI

public final class MonacoEditorConfiguration: ObservableObject {
  public enum LineNumbersType: Equatable {
    case on
    case off
    case relative
    case interval
    case function(String)

    var javascript: String {
      switch self {
      case .on: return "on"
      case .off: return "off"
      case .relative: return "relative"
      case .interval: return "interval"
      case .function(let javascript): return javascript
      }
    }
  }

  public enum WordWrap: String {
    case off
    case on
    case wordWrapColumn
    case bounded
  }

  public enum WrappingIndent: String {
    case none
    case same
    case indent
    case deepIndent
  }

  @Published public var language: String?
  @Published public var lineNumbers: LineNumbersType?
  @Published public var readOnly: Bool?
  @Published public var roundedSelection: Bool?
  @Published public var scrollBeyondLastLine: Bool?
  @Published public var theme: String?
  @Published public var wordWrap: WordWrap?
  @Published public var wordWrapColumn: Int?
  @Published public var wordWrapMinified: Bool?
  @Published public var wrappingIndent: WrappingIndent?

  public init(
    language: String? = nil,
    lineNumbers: LineNumbersType? = nil,
    readOnly: Bool? = nil,
    roundedSelection: Bool? = nil,
    scrollBeyondLastLine: Bool? = nil,
    theme: String? = nil,
    wordWrap: WordWrap? = nil,
    wordWrapColumn: Int? = nil,
    wordWrapMinified: Bool? = nil,
    wrappingIndent: WrappingIndent? = nil
  ) {
    self.language = language
    self.lineNumbers = lineNumbers
    self.readOnly = readOnly
    self.roundedSelection = roundedSelection
    self.scrollBeyondLastLine = scrollBeyondLastLine
    self.theme = theme
    self.wordWrap = wordWrap
    self.wordWrapColumn = wordWrapColumn
    self.wordWrapMinified = wordWrapMinified
  }
}
