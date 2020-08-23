// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

public indirect enum MonacoEditorKeyBinding {
  case key(MonacoEditorKeyCode)
  case alt(MonacoEditorKeyCode)
  case ctrlCmd(MonacoEditorKeyCode)
  case shift(MonacoEditorKeyCode)
  case winCtrl(MonacoEditorKeyCode)
  case chord(MonacoEditorKeyBinding, MonacoEditorKeyBinding)

  var keybinding: String {
    switch self {
    case .key(let value):
      return "monaco.KeyCode.\(value.rawValue)"

    case .alt(let value):
      return "monaco.KeyMod.Alt | monaco.KeyCode.\(value.rawValue)"

    case .ctrlCmd(let value):
      return "monaco.KeyMod.CtrlCmd | monaco.KeyCode.\(value.rawValue)"

    case .shift(let value):
      return "monaco.KeyMod.Shift | monaco.KeyCode.\(value.rawValue)"

    case .winCtrl(let value):
      return "monaco.KeyMod.WinCtrl | monaco.KeyCode.\(value.rawValue)"

    case .chord(let first, let second):
      return "monaco.KeyMod.chord(\(first.keybinding), \(second.keybinding))"
    }
  }
}
