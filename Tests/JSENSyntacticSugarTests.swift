// Copyright © 2021 Roger Oba. All rights reserved.

import XCTest
@testable import JSEN

final class JSENSyntacticSugarTests : XCTestCase {
    func test_expressibleByIntegerLiteral_shouldHaveTheRightAssociatedValue() {
        let jsenLiteral: JSEN = 77
        XCTAssertEqual(jsenLiteral.valueType as? Int, 77)
    }

    func test_expressibleByFloatLiteral_shouldHaveTheRightAssociatedValue() {
        let jsenLiteral: JSEN = 24.46
        XCTAssertEqual(jsenLiteral.valueType as? Double, 24.46)
    }

    func test_expressibleByStringLiteral_shouldHaveTheRightAssociatedValue() {
        let jsenLiteral: JSEN = "string literal"
        XCTAssertEqual(jsenLiteral.valueType as? String, "string literal")
    }

    func test_expressibleByBooleanLiteral_shouldHaveTheRightAssociatedValue() {
        let jsenLiteral: JSEN = true
        XCTAssertEqual(jsenLiteral.valueType as? Bool, true)
    }

    func test_expressibleByArrayLiteral_shouldHaveTheRightAssociatedValue() {
        let jsenLiteral: JSEN = [ "this", "is", "an", "array" ]
        XCTAssertEqual(jsenLiteral.valueType as? [String], [ "this", "is", "an", "array" ])
    }

    func test_expressibleByDictionaryLiteral_shouldHaveTheRightAssociatedValue() {
        let jsenLiteral: JSEN = [ "this is it" : "some value" ]
        XCTAssertEqual(jsenLiteral.valueType as? [String:String], [ "this is it" : "some value" ])
    }

    func test_expressibleByNilLiteral_shouldHaveTheRightAssociatedValue() {
        let jsenLiteral: JSEN = nil
        XCTAssertNil(jsenLiteral.valueType)
    }

    func test_prefixOperator_withInt_shouldHaveTheRightAssociatedValue() {
        let value: Int = 67
        let jsenValue: JSEN = %value
        XCTAssertEqual(jsenValue.valueType as? Int, value)
    }

    func test_prefixOperator_withDouble_shouldHaveTheRightAssociatedValue() {
        let value: Double = 3.14
        let jsenValue: JSEN = %value
        XCTAssertEqual(jsenValue.valueType as? Double, value)
    }

    func test_prefixOperator_withString_shouldHaveTheRightAssociatedValue() {
        let value: String = "testing value"
        let jsenValue: JSEN = %value
        XCTAssertEqual(jsenValue.valueType as? String, value)
    }

    func test_prefixOperator_withBool_shouldHaveTheRightAssociatedValue() {
        let value: Bool = true
        let jsenValue: JSEN = %value
        XCTAssertEqual(jsenValue.valueType as? Bool, value)
    }

    func test_prefixOperator_withArray_shouldHaveTheRightAssociatedValue() {
        let value: [JSEN] = [ "my element" ]
        let jsenValue: JSEN = %value
        XCTAssertEqual(jsenValue.valueType as? [String], [ "my element" ])
    }

    func test_prefixOperator_withDictionary_shouldHaveTheRightAssociatedValue() {
        let value: [String:JSEN] = [ "key" : "value" ]
        let jsenValue: JSEN = %value
        XCTAssertEqual(jsenValue.valueType as? [String:String], [ "key" : "value" ])
    }
}
