// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import SwiftUI

public final class MonacoEditorMinimapOptions: ObservableObject {
  public enum ShowSlider {
    case always
    case mouseover
  }

  public enum Side {
    case right
    case left
  }

  @Published public var enabled: Bool?
  @Published public var maxColumn: Int?
  @Published public var renderCharacters: Bool?
  @Published public var scale: Float?
  @Published public var showSlider: ShowSlider?
  @Published public var side: Side?

  public init(
    enabled: Bool? = nil,
    maxColumn: Int? = nil,
    renderCharacters: Bool? = nil,
    scale: Float? = nil,
    showSlider: ShowSlider? = nil,
    side: Side? = nil
  ) {
    self.enabled = enabled
    self.maxColumn = maxColumn
    self.renderCharacters = renderCharacters
    self.scale = scale
    self.showSlider = showSlider
    self.side = side
  }
}
