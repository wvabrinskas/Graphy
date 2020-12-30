import XCTest
@testable import Graphy

final class GraphyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Graphy().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
