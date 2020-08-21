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

import * as monaco from 'monaco-editor';
import './styles.css';

(function() {
    class MonacoEditorHost {
        constructor() {}

        create(options) {
            const hostElement = document.createElement('div');
            hostElement.id = 'editor';
            document.body.appendChild(hostElement);

            this.editor = monaco.editor.create(hostElement, options);
            this.editor.focus();
            this.editor.onDidChangeModelContent((event) => {
                var text = this.editor.getValue();
                window.webkit.messageHandlers.updateText.postMessage(btoa(text));
            });
        }

        addCommand(fn) {
            fn(monaco, this.editor);
        }

        focus() {
            this.editor.focus();
        }

        setText(text) {
            this.editor.setValue(text);
        }

        updateOptions(options) {
            this.editor.updateOptions(options);
        }
    }

    function main() {
        window.editor = new MonacoEditorHost();
    }

    document.addEventListener('DOMContentLoaded', main);
})();
