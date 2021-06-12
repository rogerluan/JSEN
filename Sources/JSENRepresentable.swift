// Copyright © 2021 Roger Oba. All rights reserved.

/// Defines a type that can be convered to a JSEN.
public protocol JSENRepresentable : Codable {
    func asJSEN() -> JSEN
}

extension Int : JSENRepresentable {
    public func asJSEN() -> JSEN {
        return .int(self)
    }
}

extension Double : JSENRepresentable {
    public func asJSEN() -> JSEN {
        return .double(self)
    }
}

extension String : JSENRepresentable {
    public func asJSEN() -> JSEN {
        return .string(self)
    }
}

extension Bool : JSENRepresentable {
    public func asJSEN() -> JSEN {
        return .bool(self)
    }
}

extension Array : JSENRepresentable where Element == JSEN {
    public func asJSEN() -> JSEN {
        return .array(self)
    }
}

extension Dictionary : JSENRepresentable where Key == String, Value == JSEN {
    public func asJSEN() -> JSEN {
        return .dictionary(self)
    }
}

extension Optional : JSENRepresentable where Wrapped : JSENRepresentable {
    public func asJSEN() -> JSEN {
        switch self {
        case .none: return .null
        case .some(let jsen): return jsen.asJSEN()
        }
    }
}

extension RawRepresentable where RawValue : JSENRepresentable {
    public func asJSEN() -> JSEN {
        return rawValue.asJSEN()
    }
}
