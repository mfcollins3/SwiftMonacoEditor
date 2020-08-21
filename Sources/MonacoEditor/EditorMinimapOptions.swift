// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import Foundation

struct EditorMinimapOptions: Codable {
  let enabled: Bool?
  let maxColumn: Int?
  let renderCharacters: Bool?
  let scale: Float?
  let showSlider: String?
  let side: String?

  init(_ options: MonacoEditorMinimapOptions) {
    enabled = options.enabled
    maxColumn = options.maxColumn
    renderCharacters = options.renderCharacters
    scale = options.scale

    if let value = options.showSlider {
      switch value {
      case .always: showSlider = "always"
      case .mouseover: showSlider = "mouseover"
      }
    } else {
      showSlider = nil
    }

    if let value = options.side {
      switch value {
      case .left: side = "left"
      case .right: side = "right"
      }
    } else {
      side = nil
    }
  }
}
