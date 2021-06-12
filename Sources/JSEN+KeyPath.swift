// Copyright © 2021 Roger Oba. All rights reserved.

public extension JSEN {
    subscript(_ key: String) -> JSEN? {
        get {
            switch self {
            case .dictionary(let value): return value[key]
            default: return nil
            }
        }
        set {
            switch self {
            case .dictionary(var value):
                value[key] = newValue
                self = .dictionary(value)
            default: break
            }
        }
    }

    subscript(keyPath keyPath: KeyPath) -> JSEN? {
        get {
            switch keyPath.headAndTail() {
            case nil: return nil // Key path is empty.
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                return self[head]
            case let (head, remainingKeyPath)?:
                // Key path has a tail we need to traverse.
                let remaining = self[keyPath: KeyPath(head)]
                if let jsen = remaining, case .dictionary(let nestedDictionary) = jsen {
                    // Nest level is a dictionary-like JSEN value.
                    // Recursively access dictionary's values with the remaining key path.
                    return nestedDictionary[keyPath: remainingKeyPath] as? JSEN
                } else {
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
                self[head] = newValue
            case let (head, remainingKeyPath)?:
                let value = self[keyPath: KeyPath(head)]
                if let jsonValue = value, case .dictionary(var nestedDictionary) = jsonValue {
                    // Key path has a tail we need to traverse
                    nestedDictionary[keyPath: remainingKeyPath] = newValue
                    self[head] = JSEN.dictionary(nestedDictionary)
                } else {
                    // Invalid keyPath
                    return
                }
            }
        }
    }
}
