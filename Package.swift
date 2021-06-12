// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSEN",
    products: [
        .library(name: "JSEN", targets: ["JSEN"]),
    ],
    targets: [
        .target(
            name: "JSEN",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "JSENTests",
            dependencies: ["JSEN"],
            path: "Tests"
        ),
    ]
)
