import XCTest
@testable import AnnotationGet

final class AnnotationGetTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AnnotationGet().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
