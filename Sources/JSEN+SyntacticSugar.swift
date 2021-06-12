// Copyright © 2021 Roger Oba. All rights reserved.

extension JSEN : ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = value.asJSEN()
    }
}
extension JSEN : ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = value.asJSEN()
    }
}
extension JSEN : ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = value.asJSEN()
    }
}
extension JSEN : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = value.asJSEN()
    }
}
extension JSEN : ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSEN...) {
        self = elements.asJSEN()
    }
}
extension JSEN : ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSEN)...) {
        self = .dictionary(elements.reduce(into: [:]) { $0[$1.0] = $1.1 })
    }
}
extension JSEN : ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .null
    }
}

prefix operator %
prefix func % (rhs: Int) -> JSEN { .int(rhs) }
prefix func % (rhs: Double) -> JSEN { .double(rhs) }
prefix func % (rhs: String) -> JSEN { .string(rhs) }
prefix func % (rhs: Bool) -> JSEN { .bool(rhs) }
prefix func % (rhs: [JSEN]) -> JSEN { .array(rhs) }
prefix func % (rhs: [String:JSEN]) -> JSEN { .dictionary(rhs) }
