// Copyright © 2021 Roger Oba. All rights reserved.

import Foundation

extension JSEN : Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int): try container.encode(int)
        case .double(let double): try container.encode(double)
        case .string(let string): try container.encode(string)
        case .bool(let bool): try container.encode(bool)
        case .array(let array): try container.encode(array)
        case .dictionary(let dictionary): try container.encode(dictionary)
        case .null: try container.encodeNil()
        }
    }
}

extension JSEN : Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([JSEN].self) {
            self = .array(value)
        } else if let value = try? container.decode([String:JSEN].self) {
            self = .dictionary(value)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw NSError(domain: "domain.codable.jsen", code: 1, userInfo: [ "message" : "Failed to decode JSEN into any known type." ])
        }
    }

    /// Decodes **self** into the given type, if possible.
    ///
    /// This method will attempt to decode to the given type by first encoding **self** to Data, and then attempting to decode that Data.
    /// If this step fails, it will attempt to encode **self** using utf8 if **self** is a `.string` case. If it succeeds, it will attempt to
    /// decode into the given type using the resulting Data.
    ///
    /// - Parameters:
    ///   - type: the Decodable type to decode **self** into.
    ///   - dumpingErrorOnFailure: whether the function should dump the error on the console, upon failure. Set true for debugging purposes. Defaults to false.
    /// - Returns: An instance of the given type, or nil if the decoding wasn't possible.
    public func decode<T : Decodable>(as type: T.Type, dumpingErrorOnFailure: Bool = false) -> T? {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            do {
                switch self {
                case .string(let string):
                    guard let data = string.data(using: .utf8) else {
                        // Should never happen
                        assertionFailure("Received a string that is utf8-encoded. This is a provider precondition, please investigate why this provider is sending strings encoded in something different than utf8.")
                        return nil
                    }
                    return try JSONDecoder().decode(type, from: data)
                default: throw error
                }
            } catch {
                if dumpingErrorOnFailure {
                    dump(error)
                }
                return nil
            }
        }
    }
}
