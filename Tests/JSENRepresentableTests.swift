// Copyright © 2021 Roger Oba. All rights reserved.

import XCTest
@testable import JSEN

final class JSENRepresentableTests : XCTestCase {
    func test_asJSEN_shouldReturnTheRightAssociatedValue() {
        enum Test : String {
            case myFirstCase
        }
        XCTAssertEqual(42.asJSEN(), .int(42))
        XCTAssertEqual(3.14.asJSEN(), .double(3.14))
        XCTAssertEqual("testing".asJSEN(), .string("testing"))
        XCTAssertEqual(true.asJSEN(), .bool(true))
        XCTAssertEqual(["testing"].asJSEN(), .array(["testing"]))
        XCTAssertEqual(["testing" : "value"].asJSEN(), .dictionary(["testing" : "value"]))
        XCTAssertEqual(Optional<String>.none.asJSEN(), .null)
        XCTAssertEqual(Test.myFirstCase.asJSEN(), .string("myFirstCase"))
    }
}
