// Copyright © 2021 Roger Oba. All rights reserved.

import Foundation

/// Simple struct used to represent multiple segments of a string.
/// This is a utility used to recursively access values in nested dictionaries.
public struct KeyPath: Hashable {
    public var segments: [String]

    public var isEmpty: Bool { return segments.isEmpty }
    public var path: String {
        return segments.joined(separator: ".")
    }

    /// Strips off the first segment and returns a pair
    /// consisting of the first segment and the remaining key path.
    /// Returns nil if the key path has no segments.
    public func headAndTail() -> (head: String, tail: KeyPath)? {
        guard !isEmpty else { return nil }
        var tail = segments
        let head = tail.removeFirst()
        return (head, KeyPath(segments: tail))
    }
}

/// Initializes a KeyPath with a string of the form "this.is.a.keypath"
public extension KeyPath {
    init(_ string: String) {
        let segments = string.components(separatedBy: ".")
        if segments.count == 1 && segments.first!.isEmpty {
            self.segments = []
        } else {
            self.segments = segments
        }
    }
}

extension KeyPath: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension KeyPath: CustomStringConvertible {
    public var description: String {
        return segments.joined(separator: ".")
    }
}

public extension KeyPath {
    static func + (lhs: KeyPath, rhs: KeyPath) -> KeyPath {
        return KeyPath(lhs.description + "." + rhs.description)
    }
}

public extension Dictionary where Key == String {
    subscript(keyPath keyPath: KeyPath) -> Any? {
        get {
            switch keyPath.headAndTail() {
            case nil: return nil // Key path is empty.
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                return self[head]
            case let (head, remainingKeyPath)?:
                // Key path has a tail we need to traverse.
                let remaining = self[head]
                if let nestedDictionary = remaining as? [Key:Any] {
                    // Next nest level is a dictionary.
                    // Recursively access dictionary's values with the remaining key path.
                    return nestedDictionary[keyPath: remainingKeyPath]
                } else if let jsonValue = remaining as? JSEN, case .dictionary(let nestedDictionary) = jsonValue {
                    // It's a dictionary-like JSONValue.
                    // Recursively access dictionary's values with the remaining key path.
                    return nestedDictionary[keyPath: remainingKeyPath]
                } else {
                    // Next nest level isn't a dictionary nor a dictionary-like JSONValue
                    // Invalid key path, abort.
                    return nil
                }
            }
        }
        set {
            switch keyPath.headAndTail() {
            case nil: return // Key path is empty.
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                self[head] = newValue as? Value
            case let (head, remainingKeyPath)?:
                let value = self[head]
                if var nestedDictionary = value as? [Key:Any] {
                    // Key path has a tail we need to traverse
                    nestedDictionary[keyPath: remainingKeyPath] = newValue
                    self[head] = nestedDictionary as? Value
                } else if let jsonValue = value as? JSEN, case .dictionary(var nestedDictionary) = jsonValue {
                    // Key path has a tail we need to traverse
                    nestedDictionary[keyPath: remainingKeyPath] = newValue
                    self[head] = JSEN.dictionary(nestedDictionary) as? Value
                } else {
                    // Invalid keyPath
                    return
                }
            }
        }
    }
}
