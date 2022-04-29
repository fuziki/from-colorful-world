// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppMain",
            targets: ["AppMain"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "combine-schedulers", url: "https://github.com/pointfreeco/combine-schedulers.git", from: "0.5.3"),
        .package(name: "SwiftEntryKit", url: "https://github.com/huri000/SwiftEntryKit.git", from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppleExtensions",
            dependencies: []),
        .target(
            name: "AppMain",
            dependencies: [
                .target(name: "Assets"),
                .target(name: "AppleExtensions"),
                .target(name: "Core"),
                .target(name: "InAppMessage"),
                .target(name: "PortableDocumentFormat"),
                .target(name: "QRCode"),
                .target(name: "UIComponents"),
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]),
        .target(
            name: "Assets",
            dependencies: [],
            exclude: ["Token/_AppToken.swift"],
            resources: [.process("ResourceFiles")]),
        .target(
            name: "Core",
            dependencies: []),
        .target(
            name: "InAppMessage",
            dependencies: [
                .product(name: "SwiftEntryKit", package: "SwiftEntryKit"),
            ]),
        .target(
            name: "PortableDocumentFormat",
            dependencies: [
                .target(name: "AppleExtensions"),
            ]),
        .target(
            name: "QRCode",
            dependencies: []),
        .target(
            name: "UIComponents",
            dependencies: [
                .target(name: "AppleExtensions"),
            ]),
        .testTarget(
            name: "AppMainTests",
            dependencies: ["AppMain"],
            exclude: ["AppMainTest.xctestplan"])
    ]
)
