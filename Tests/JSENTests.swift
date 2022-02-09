// Copyright © 2021 Roger Oba. All rights reserved.

import XCTest
@testable import JSEN

final class JSENTests : XCTestCase {
    func test_valueType_shouldMatchUnderlyingValue() {
        XCTAssertEqual(JSEN.int(42).valueType as? Int, 42)
        XCTAssertEqual(JSEN.double(3.14).valueType as? Double, 3.14)
        XCTAssertEqual(JSEN.string("hello").valueType as? String, "hello")
        XCTAssertEqual(JSEN.bool(false).valueType as? Bool, false)
        XCTAssertEqual(JSEN.bool(true).valueType as? Bool, true)
        XCTAssertEqual(JSEN.array(["some array", "2nd element"]).valueType as? [String], ["some array", "2nd element"])
        XCTAssertEqual(JSEN.dictionary(["my_key" : "my_value"]).valueType as? [String:String], ["my_key" : "my_value"])
        XCTAssertNil(JSEN.null.valueType)
    }

    struct Model : Decodable {
        var key: String
    }

    func test_decodeAsType_withValidTypeFromDictionary_shouldDecode() {
        let jsen = JSEN.dictionary(["key" : "value"])
        let decoded = jsen.decode(as: Model.self)
        XCTAssertEqual(decoded?.key, "value")
    }

    func test_decodeAsType_withValidTypeFromEncodedString_shouldDecode() {
        let jsen = JSEN.string(#"{"key":"value"}"#)
        let decoded = jsen.decode(as: Model.self)
        XCTAssertEqual(decoded?.key, "value")
    }

    func test_decodeAsType_withInvalidType_shouldReturnNil() {
        let jsen = JSEN.dictionary(["wrong_key" : "value"])
        let decoded = jsen.decode(as: Model.self, dumpingErrorOnFailure: true)
        XCTAssertNil(decoded)
    }

    func test_JSENCustomStringConvertible() {
        XCTAssertEqual(JSEN.int(42).description, "42")
        XCTAssertEqual(JSEN.double(3.14).description, "3.14")
        XCTAssertEqual(JSEN.string("hello").description, #""hello""#)
        XCTAssertEqual(JSEN.bool(false).description, "false")
        XCTAssertEqual(JSEN.bool(true).description, "true")
        XCTAssertEqual(JSEN.array(["some array", "2nd element"]).description, #"["some array", "2nd element"]"#)
        XCTAssertEqual(JSEN.dictionary(["my_key" : "my_value"]).description, #"["my_key": "my_value"]"#)
        XCTAssertEqual(JSEN.null.description, "null")
    }

    func test_initializer_withFlatValues_shouldMatchTheExpectedValues() {
        let int: Any? = 42
        XCTAssertEqual(JSEN(from: int), .int(42))
        let double: Any? = 42.42
        XCTAssertEqual(JSEN(from: double), .double(42.42))
        let string: Any? = "testing"
        XCTAssertEqual(JSEN(from: string), .string("testing"))
        let bool: Any? = true
        XCTAssertEqual(JSEN(from: bool), .bool(true))
        let array: Any? = [ 42 ]
        XCTAssertEqual(JSEN(from: array), .array([42]))
        let dictionary: Any? = [ "key" : 42 ]
        XCTAssertEqual(JSEN(from: dictionary), .dictionary(["key" : 42]))
        let jsen: Any? = JSEN.int(42)
        XCTAssertEqual(JSEN(from: jsen), .int(42))
    }

    func test_initializer_withNestedValues_shouldSucceed() {
        let array: Any? = [
            42,
            "42",
            true,
            [
                24,
                "24",
                false,
            ],
        ]
        XCTAssertNotNil(JSEN(from: array))
        let dictionary: Any? = [
            "key" : 42,
            "another" : true,
            "nested" : [
                "key" : true,
                "another" : "yes",
                "bool" : false,
                "double" : 3.14,
                "3rd" : [
                    "yup" : "it works",
                ]
            ]
        ]
        XCTAssertNotNil(JSEN(from: dictionary))
    }
}
