import XCTest
@testable import OSLogHandler

final class OSLogHandlerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OSLogHandler().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
