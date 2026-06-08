// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-get",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "swift-get", targets: ["swift-get"]),
        .library(name: "SwiftGetCore", targets: ["SwiftGetCore"])
    ],
    targets: [
        .target(name: "SwiftGetCore"),
        .executableTarget(
            name: "swift-get",
            dependencies: ["SwiftGetCore"]
        ),
        .testTarget(
            name: "SwiftGetCoreTests",
            dependencies: ["SwiftGetCore"]
        )
    ]
)
