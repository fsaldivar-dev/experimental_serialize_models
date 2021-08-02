import XCTest
@testable import AnnotationXML

final class AnnotationXMLTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AnnotationXML().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
