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

import Combine
import SwiftUI

public struct MonacoEditor: UIViewRepresentable {
  private let commands: [MonacoEditorCommand]?
  private let contentChanged: ((String) -> Void)?

  @ObservedObject private var configuration: MonacoEditorConfiguration
  @Binding private var text: String

  public init(
    text: Binding<String>,
    configuration: MonacoEditorConfiguration,
    commands: [MonacoEditorCommand]? = nil,
    contentChanged: ((String) -> Void)? = nil
  ) {
    self._text = text
    self.configuration = configuration
    self.contentChanged = contentChanged
    self.commands = commands
  }

  public func makeCoordinator() -> Coordinator {
    let coordinator = Coordinator(commands: commands)
    return coordinator
  }

  public func makeUIView(context: Context) -> MonacoEditorView {
    let view = MonacoEditorView(
      frame: .zero,
      text: text,
      configuration: configuration
    )
    view.ready = context.coordinator.configureEditor
    view.contentChanged = contentChanged
    view.text = text
    return view
  }

  public func updateUIView(_ uiView: MonacoEditorView, context: Context) {
    uiView.updateConfiguration()
    uiView.text = text
  }
}

extension MonacoEditor {
  public final class Coordinator {
    private let commands: [MonacoEditorCommand]?

    init(commands: [MonacoEditorCommand]?) {
      self.commands = commands
    }

    func configureEditor(editor: MonacoEditorView) {
      if let commands = self.commands {
        for command in commands {
          editor.addCommand(command)
        }
      }
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var configuration = MonacoEditorConfiguration(language: "markdown")
  @State static var text = ""

  static var previews: some View {
    MonacoEditor(text: $text, configuration: configuration)
  }
}
