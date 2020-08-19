import XCTest
@testable import MonacoEditor

final class SwiftMonacoEditorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftMonacoEditor().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
