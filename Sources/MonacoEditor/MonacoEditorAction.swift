// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import Foundation

public struct MonacoEditorAction {
  let contextMenuGroupID: String?
  let contextMenuOrder: Float?
  let id: String
  let keybindingContext: String?
  let keybindings: [MonacoEditorKeyBinding]?
  let label: String
  let precondition: String?
  let run: String

  public init(
    id: String,
    label: String,
    contextMenuGroupID: String? = nil,
    contextMenuOrder: Float? = nil,
    keybindingContext: String? = nil,
    keybindings: [MonacoEditorKeyBinding]? = nil,
    precondition: String? = nil,
    run: String
  ) {
    self.contextMenuGroupID = contextMenuGroupID
    self.contextMenuOrder = contextMenuOrder
    self.id = id
    self.keybindingContext = keybindingContext
    self.keybindings = keybindings
    self.label = label
    self.precondition = precondition
    self.run = run
  }
}
