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
}
