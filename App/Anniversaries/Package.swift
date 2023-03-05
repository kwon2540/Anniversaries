// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Anniversaries",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "AppKit", targets: ["AppKit"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "Home", targets: ["Home"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.51.0"),
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
                "Home",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Home",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)
