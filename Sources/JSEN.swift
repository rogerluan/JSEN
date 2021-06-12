// Copyright © 2021 Roger Oba. All rights reserved.

/// A simple JSON value representation using enum cases.
public enum JSEN : Equatable {
    /// An integer value.
    case int(Int)
    /// A floating point value.
    case double(Double)
    /// A string value.
    case string(String)
    /// A boolean value.
    case bool(Bool)
    /// An array value in which all elements are also JSEN values.
    indirect case array([JSEN])
    /// An object value, also known as dictionary, hash, and map.
    /// All values of this object are also JSEN values.
    indirect case dictionary([String:JSEN])
    /// A null value.
    case null

    /// The extracted value from **self**, or **nil** if **self** is a `.null` case.
    public var valueType: Any? {
        switch self {
        case .int(let value): return value
        case .double(let value): return value
        case .string(let value): return value
        case .bool(let value): return value
        case .array(let array): return array.map { $0.valueType }
        case .dictionary(let dictionary): return dictionary.mapValues { $0.valueType }
        case .null: return nil
        }
    }
}

extension JSEN : CustomStringConvertible {
    public var description: String {
        switch self {
        case .int(let value): return value.description
        case .double(let value): return value.description
        case .string(let value): return "\"\(value)\""
        case .bool(let value): return value.description
        case .array(let value): return value.description // TODO: Improve printing
        case .dictionary(let value): return value.description // TODO: Improve printing
        case .null: return "null"
        }
    }
}

extension JSEN : CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}
