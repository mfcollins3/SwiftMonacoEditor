#!/usr/bin/env bash

# Copyright 2020 Michael F. Collins, III
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# build_web.sh
#
# This script automates the steps required to build the web assets that will
# be hosted in a WKWebView.
#
# Usage: bin/build_web.sh

# Use webpack to package all of the assets.

pushd Web > /dev/null

npx webpack --mode=production

popd > /dev/null

# The generated assets will be very big. We'll gzip compress the assets before
# they are embedded in the module's bundle in order to decrease the on-disk
# size of applications that use this module.

pushd Sources/MonacoEditor/Editor > /dev/null

gzip -r .

# Remove the .gz extension from the compressed files.

for file in *.gz; do
    mv -- "$file" "${file%%.gz}"
done

popd > /dev/null

echo "Completed"
