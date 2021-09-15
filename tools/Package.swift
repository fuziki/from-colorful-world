// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tools",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/mono0926/LicensePlist", from: "3.0.5"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.43.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "tools",
            dependencies: []),
        .testTarget(
            name: "toolsTests",
            dependencies: ["tools"]),
    ]
)
