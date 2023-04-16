// swift-tools-version: 5.7
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
        .library(name: "Settings", targets: ["Settings"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.51.0"),
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
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]
        ),
        .target(
            name: "Home",
            dependencies: [
                "AppUI",
                "Theme",
                "Settings",
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
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Settings",
            dependencies: [
                "Theme",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
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
