import XCTest
@testable import MonadicParser

final class MonadicParserTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MonadicParser().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
