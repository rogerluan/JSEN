# JSEN

> _/ˈdʒeɪsən/ JAY-sən_

JSEN (JSON Swift Enum Notation) is a lightweight enum representation of a JSON, written in Swift.

A JSON, as defined in the [ECMA-404 standard](https://www.json.org) , can be:

- A number
- A boolean
- A string
- Null
- An array of those things
- A dictionary of those things

Thus, JSONs can be represented as a recursive enum (or `indirect enum`, in Swift), effectively creating a statically-typed JSON payload in Swift.

# Installation

Using Swift Package Manager:

```swift
dependencies: [
    .package(name: "JSEN", url: "https://github.com/rogerluan/JSEN", .upToNextMajor(from: "1.0.0")),
]
```

# Usage

I think it's essential for the understanding of how simple this is, for you to visualize the JSEN declaration:

```swift
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
}
```

That's it.

### `ExpressibleBy…Literal`

Now that you're familiar with JSEN, it provides a few syntactic sugary utilities, such as conformance to most `ExpressibleBy…Literal` protocols:

- `ExpressibleByIntegerLiteral` initializer returns an `.int(…)`.
- `ExpressibleByFloatLiteral` initializer returns a `.double(…)`.
- `ExpressibleByStringLiteral` initializer returns a  `.string(…)`.
- `ExpressibleByBooleanLiteral` initializer returns a `.bool(…)`.
- `ExpressibleByArrayLiteral` initializer returns an `.array(…)` as long as its Elements are JSENs.
- `ExpressibleByDictionaryLiteral` initializer returns an `.dictionary(…)` as long as its keys are Strings and Values JSENs.
- `ExpressibleByNilLiteral` initializer returns a `.null`.

Conformance to `ExpressibleBy…Literal` protocols are great when you want to build a JSON structure like this:

```swift
let request: [String:JSEN] = [
    "key": "value",
    "another_key": 42,
]
```

But what if you're not working with literals?

```swift
let request: [String:JSEN] = [
    "amount": normalizedAmount // This won't compile
]
```

Enters the…

### `%` Suffix Operator

```swift
let request: [String:JSEN] = [
    "amount": %normalizedAmount // This works!
]
```

The custom `%` suffix operator transforms any `Int`, `Double`, `String`, `Bool`, `[JSEN]` and `[String:JSEN]` values into its respective JSEN value.


By design, no support was added to transform `Optional` into a `.null` to prevent misuse.

<details><summary>Click here to expand the reason why it could lead to mistakes</summary>
<p>

To illustrate the possible problems around an `%optionalValue` operation, picture the following scenario:

```swift
let request: [String:JSEN] = [
    "middle_name": %optionalString
]
network.post(path: "user", parameters: request)
network.put(path: "user", parameters: request)
network.patch(path: "user", parameters: request)
network.mergePatch(path: "user", parameters: request)
```

In the scenarios above, what do you think should be the RESTful expected behavior?

If the `%` operator detected a nonnull String, great. But if it detected its underlying value to be `.none` (aka `nil`), it would convert the value to `.null`, which, when encoded, would be converted to `NSNull()` (more on this below in the Codable section). As you imagine, `NSNull()` and `nil` have very different behaviors when it comes to RESTful APIs - the former might delete the key information on the database, while the latter will simply be ignored by Swift Dictionary (as if the field wasn't even there).

Hence, if you want to use an optional value, make the call explicit by using either `.null` if you know the value must be encoded into a `NSNull()` instance, or unwrap its value and wrap it around one of the non-null JSEN cases.

</p>
</details>

### Conformance to Codable

Of course! We couldn't miss this. JSEN has native support to `Encodable & Decodable` (aka `Codable`), so you can easily parse JSEN to/from JSON-like structures. Each case is mapped to its respective value type, and `.null` maps to a `NSNull()` instance (which, in a JSON, is represented by `null`).

One additional utility was added as well, which's the `decode(as:)` function. It receives a Decodable-conformant Type as parameter and will attempt to decode the JSEN value into the given type using a two-pass strategy:
- First, it encodes the JSEN to `Data`, and attempts to decode that `Data` into the given type.
- If that fails and the JSEN is a `.string(…)` case, it attempts to encode the JSEN's string using `.utf8`. If it is able to encode it, it attempts to decode the resulting `Data` into the given type.

### Subscript Using KeyPath

Last, but not least, comes the `KeyPath` subscript.

Based on [@olebegemann](https://twitter.com/olebegemann)'s [article](https://oleb.net/blog/2017/01/dictionary-key-paths), `KeyPath` is a simple struct used to represent multiple segments of a string. It is initializable by a string literal such as `"this.is.a.keypath"` and, when initialized, the string gets separated by periods, which compounds the struct's segments.

The subscript to JSEN allows the following syntax:

```swift
let request: [String:JSEN] = [
    "1st": [
        "2nd": [
            "3rd": "Hello!"
        ]
    ]
]
print(request[keyPath: "1st.2nd.3rd"]) // "Hello!"
```

Without this syntax, you'd have to create multiple chains of awkward optionals and unwrap them in weird and verbosy ways to access a nested value in a dictionary. I'm not a fan of doing that :)

# Contributions

If you spot something wrong, missing, or if you'd like to propose improvements to this project, please open an Issue or a Pull Request with your ideas and I promise to get back to you within 24 hours! 😇

# References

JSEN was heavily based on [Statically-typed JSON payload in Swift](https://jobandtalent.engineering/statically-typed-json-payload-in-swift-bd193a9e8cf2) and other various implementations of this same utility spread throughout Stack Overflow and Swift Forums. I brought everything I needed together in this project because I couldn't find something similar as a Swift Package that had everything I needed.

# License

This project is open source and covered by a standard 2-clause BSD license. That means you can use (publicly, commercially and privately), modify and distribute this project's content, as long as you mention *Roger Oba* as the original author of this code and reproduce the LICENSE text inside your app, repository, project or research paper.

# Contact

Twitter: [@rogerluan_](https://twitter.com/rogerluan_)
