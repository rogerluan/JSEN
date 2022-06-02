// Copyright © 2021 Roger Oba. All rights reserved.

import XCTest
@testable import JSEN

final class KeyPathTests : XCTestCase {
    func test_readingNestedDictionaryLiteral_shouldReadValue() {
        let nestedDictinary = [
            "1st" : [
                "2nd" : [
                    "3rd" : "hi!"
                ]
            ]
        ]
        XCTAssertEqual(nestedDictinary[keyPath: "1st.2nd.3rd"] as? String, "hi!")
    }

    func test_readingNestedJSEN_shouldReadValue() {
        let nestedJSEN = [ "1st" : JSEN.dictionary([ "2nd" : "hi!" ])]
        XCTAssertEqual((nestedJSEN[keyPath: "1st.2nd"] as? JSEN), "hi!")
    }

    func test_readingMoreKeyPathsThanAvailable_shouldReturnNil() {
        let dictionary = [ "flat_dictionary" : "some value" ]
        XCTAssertNil(dictionary[keyPath: "flat_dictionary.2nd"])
    }

    func test_readingUsingEmptyKeyPath_shouldReturnNil() {
        let dictionary = [ "flat_dictionary" : "some value" ]
        XCTAssertNil(dictionary[keyPath: ""])
    }

    func test_writingToNestedDictionaryToExistingKey_shouldOverrideExistingValue() {
        var nestedDictinary = [
            "1st" : [
                "2nd" : [
                    "3rd" : "hi!"
                ]
            ]
        ]
        nestedDictinary[keyPath: "1st.2nd.3rd"] = "hello!"
        XCTAssertEqual(nestedDictinary[keyPath: "1st.2nd.3rd"] as? String, "hello!")
    }

    func test_writingToNestedDictionaryUsingInvalidKeyPath_shouldntDoAnything() {
        let originalDictionary = [
            "1st" : [
                "2nd" : [
                    "3rd" : "hi!"
                ]
            ]
        ]
        var nestedDictinary = originalDictionary
        nestedDictinary[keyPath: "1st.2nd.3rd.4th"] = "does this work?"
        XCTAssertEqual(nestedDictinary, originalDictionary)
    }

    func test_writingToNestedJSEN_shouldOverrideExistingValue() {
        var nestedJSEN = [ "1st" : JSEN.dictionary([ "2nd" : "hi!" ])]
        // There's one limitation: the value being assigned gotta have the same value as dictionary Value type.
        nestedJSEN[keyPath: "1st.2nd"] = JSEN.string("hello!")
        XCTAssertEqual((nestedJSEN[keyPath: "1st.2nd"] as? JSEN), "hello!")
    }

    func test_writingUsingEmptyKeyPath_shouldntDoAnything() {
        let originalDictionary = [ "flat_dictionary" : "some value" ]
        var nestedDictinary = originalDictionary
        nestedDictinary[keyPath: ""] = "does this work?"
        XCTAssertEqual(nestedDictinary, originalDictionary)
    }

    func test_path_shouldMatchKeyPathInitializerPath() {
        let path = "1st.2nd.3rd"
        let keyPath = KeyPath(path)
        XCTAssertEqual(keyPath.path, path)
    }

    func test_description_whenSegmentIsEmpty_shouldReturnEmptyString() {
        XCTAssertEqual(KeyPath(""), "")
    }

    func test_description_whenSegmentHasOneElement_shouldReturnThatElement() {
        XCTAssertEqual(KeyPath("element"), "element")
    }

    func test_description_whenSegmentHasTwoElements_shouldReturnStringSeparatedByPeriod() {
        XCTAssertEqual(KeyPath("my.name"), "my.name")
    }

    func test_pathAppending_whenPathIsValid_shouldReturnAppendedPathsUsingPeriod() {
        let lhs = "this.is.path.start"
        let rhs = "this.is.path.end"
        XCTAssertEqual(KeyPath(lhs) + KeyPath(rhs), "this.is.path.start.this.is.path.end")
    }

    func test_writingToEmptyDictionary() throws {
        let data = "this is my data"
        var dictionary: [String:Any] = [:]
        dictionary[keyPath: "nested.data"] = data
        XCTAssertEqual(dictionary[keyPath: "nested.data"] as? String, data)
    }
}
