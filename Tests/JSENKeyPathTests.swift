// Copyright © 2021 Roger Oba. All rights reserved.

import XCTest
@testable import JSEN

final class JSENKeyPathTests : XCTestCase {
    func test_readingNestedDictionaryLiteral_shouldReadValue() {
        let nestedDictinary = JSEN.dictionary([
            "1st" : [
                "2nd" : [
                    "3rd" : "hi!"
                ]
            ]
        ])
        XCTAssertEqual(nestedDictinary[keyPath: "1st.2nd.3rd"], "hi!")
    }

    func test_readingNestedJSEN_shouldReadValue() {
        let nestedJSEN = JSEN.dictionary([ "1st" : JSEN.dictionary([ "2nd" : "hi!" ])])
        XCTAssertEqual(nestedJSEN[keyPath: "1st.2nd"], "hi!")
    }

    func test_readingMoreKeyPathsThanAvailable_shouldReturnNil() {
        let dictionary = JSEN.dictionary([ "flat_dictionary" : "some value" ])
        XCTAssertNil(dictionary[keyPath: "flat_dictionary.2nd"])
    }

    func test_readingUsingEmptyKeyPath_shouldReturnNil() {
        let dictionary = JSEN.dictionary([ "flat_dictionary" : "some value" ])
        XCTAssertNil(dictionary[keyPath: ""])
    }

    func test_writingToNestedDictionaryToExistingKey_shouldOverrideExistingValue() {
        var nestedDictinary = JSEN.dictionary([
            "1st" : [
                "2nd" : [
                    "3rd" : "hi!"
                ]
            ]
        ])
        nestedDictinary[keyPath: "1st.2nd.3rd"] = "hello!"
        XCTAssertEqual(nestedDictinary[keyPath: "1st.2nd.3rd"], "hello!")
    }

    func test_writingToNestedJSENUsingInvalidKeyPath_shouldntDoAnything() {
        let originalDictionary = JSEN.dictionary([
            "1st" : JSEN.dictionary([
                "2nd" : JSEN.dictionary([
                    "3rd" : "hi!"
                ])
            ])
        ])
        var nestedDictinary = originalDictionary
        nestedDictinary[keyPath: "1st.2nd.3rd.4th"] = "does this work?"
        XCTAssertEqual(nestedDictinary, originalDictionary)
    }

    func test_writingToNestedJSEN_shouldOverrideExistingValue() {
        var nestedJSEN = JSEN.dictionary([
            "1st" : JSEN.dictionary([
                "2nd" : "hi!"
            ])
        ])
        nestedJSEN[keyPath: "1st.2nd"] = "hello!"
        XCTAssertEqual(nestedJSEN[keyPath: "1st.2nd"], "hello!")
    }

    func test_writingUsingEmptyKeyPath_shouldntDoAnything() {
        let originalDictionary = JSEN.dictionary([ "flat_dictionary" : "some value" ])
        var nestedDictinary = originalDictionary
        nestedDictinary[keyPath: ""] = "does this work?"
        XCTAssertEqual(nestedDictinary, originalDictionary)
    }

    func test_writingUsingSingleLevelKeyPath_shouldOverrideExistingValue() {
        var nestedDictinary = JSEN.dictionary([ "flat_dictionary" : "some value" ])
        nestedDictinary[keyPath: "flat_dictionary"] = "another value"
        XCTAssertEqual(nestedDictinary["flat_dictionary"], "another value")
    }

    func test_writingUsingInvalidKeyPath_shouldntDoAnything() {
        let originalDictionary = JSEN.dictionary([ "flat_dictionary" : "some value" ])
        var nestedDictinary = originalDictionary
        nestedDictinary[keyPath: "."] = "does this work?"
        XCTAssertEqual(nestedDictinary, originalDictionary)
    }
}
