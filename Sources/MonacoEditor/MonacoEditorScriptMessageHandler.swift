// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import Foundation
import WebKit

public struct MonacoEditorScriptMessageHandler {
  let name: String
  let scriptMessageHandler: WKScriptMessageHandler?
  let scriptMessageHandlerWithReply: WKScriptMessageHandlerWithReply?

  init(_ scriptMessageHandler: WKScriptMessageHandler, name: String) {
    self.name = name
    self.scriptMessageHandler = scriptMessageHandler
    self.scriptMessageHandlerWithReply = nil
  }

  @available(iOS 14.0, *)
  init(
    _ scriptMessageHandlerWithReply: WKScriptMessageHandlerWithReply,
    name: String
  ) {
    self.name = name
    self.scriptMessageHandler = nil
    self.scriptMessageHandlerWithReply = scriptMessageHandlerWithReply
  }
}
