// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

public struct MonacoEditorCommand {
  public let keyBinding: MonacoEditorKeyBinding
  public let command: String
  public let context: String?

  public init(
    keyBinding: MonacoEditorKeyBinding,
    context: String? = nil,
    command: String
  ) {
    self.keyBinding = keyBinding
    self.command = command
    self.context = context
  }
}
