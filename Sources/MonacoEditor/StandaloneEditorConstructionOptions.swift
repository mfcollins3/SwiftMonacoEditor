// Copyright 2020 Naked Software, LLC
//
// This program is confidential and proprietary to Naked Software, LLC,
// and may not be reproduced, published, or disclosed to others without
// company authorization.

import Foundation

struct StandaloneEditorConstructionOptions: Codable {
  let language: String?

  init(_ configuration: MonacoEditorConfiguration) {
    self.language = configuration.language
  }
}
