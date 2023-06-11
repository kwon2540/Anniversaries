// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Anniversaries",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "AppKit", targets: ["AppKit"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "Home", targets: ["Home"]),
        .library(name: "Theme", targets: ["Theme"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "Core", targets: ["Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "prerelease/1.0"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", exact: "6.6.2")
    ],
    targets: [
        .target(
            name: "AppKit",
            dependencies: [
                "AppFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "AppUI",
                "Home",
                "Theme",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppUI",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "Home",
            dependencies: [
                "Core",
                "AppUI",
                "Theme",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Theme",
            dependencies: [
                "AppUI",
                "UserDefaultsClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                "Core",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Core",
            dependencies: []
        ),
        .testTarget(
            name: "ThemeTests",
            dependencies: [
                "Theme",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)
