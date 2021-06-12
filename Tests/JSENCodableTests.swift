// Copyright © 2021 Roger Oba. All rights reserved.

import XCTest
@testable import JSEN

final class JSENCodableTests : XCTestCase {
    struct Model : Codable {
        var name: String?
        var age: Int?
        var height: Double?
        var isAlive: Bool?
        var skills: [String]?
        var address: Address?
        var isMineral: Bool?

        struct Address : Codable {
            var country: String?
        }
    }
    func test_codable_withDictionaryLiteral_shouldSucceed() throws {
        let dictionary: [String:JSEN] = [
            "name" : "John Doe",
            "age" : 21,
            "height" : 1.73,
            "isAlive" : true,
            "skills" : ["Coding", "Reading", "Writing"],
            "address" : .dictionary(["country" : "Greenland" ]),
            "isMineral": .null,
        ]
        let jsen = JSEN.dictionary(dictionary)
        let data = try JSONEncoder().encode(jsen)
        let model = try JSONDecoder().decode(Model.self, from: data)
        XCTAssertEqual(model.name, "John Doe")
        XCTAssertEqual(model.age, 21)
        XCTAssertEqual(model.height, 1.73)
        XCTAssertEqual(model.isAlive, true)
        XCTAssertEqual(model.skills, ["Coding", "Reading", "Writing"])
        XCTAssertEqual(model.address?.country, "Greenland")
        XCTAssertNil(model.isMineral)

        let newJSEN = try JSONDecoder().decode(JSEN.self, from: data)
        XCTAssertEqual(newJSEN, jsen)
    }

    func test_codable_withEncodedString_shouldSucceed() throws {
        let json = """
        {
             "name": "John Doe",
             "age": 21,
             "height": 1.73,
             "isAlive": true,
             "skills": ["Coding", "Reading", "Writing"],
             "address": {
                 "country": "Greenland"
             },
             "isMineral": null
        }
        """
        let jsen = try JSONDecoder().decode(JSEN.self, from: json.data(using: .utf8)!)
        let expectedJSEN = JSEN.dictionary([
            "name" : "John Doe",
            "age" : 21,
            "height" : 1.73,
            "isAlive" : true,
            "skills" : ["Coding", "Reading", "Writing"],
            "address" : .dictionary(["country" : "Greenland" ]),
            "isMineral": .null,
        ])
        XCTAssertEqual(jsen, expectedJSEN)
    }
}
