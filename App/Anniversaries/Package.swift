// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Anniversaries",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "AnniversariesKit", targets: ["AnniversariesKit"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "Home", targets: ["Home"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "CoreKit", targets: ["CoreKit"]),
        .library(name: "AddAndEdit", targets: ["AddAndEdit"]),
        .library(name: "Detail", targets: ["Detail"]),
        .library(name: "RemindScheduler", targets: ["RemindScheduler"]),
        .library(name: "SwiftDataClient", targets: ["SwiftDataClient"]),
        .library(name: "UserNotificationClient", targets: ["UserNotificationClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.9.2"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .target(
            name: "AnniversariesKit",
            dependencies: [
                "AppFeature",
                "UserNotificationClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "AppUI",
                "Home",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppUI",
            dependencies: [
                "AppMacros",
                "CoreKit",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "Home",
            dependencies: [
                "CoreKit",
                "AppUI",
                "AddAndEdit",
                "Detail",
                "License",
                "SwiftDataClient",
                "UserDefaultsClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "License",
            dependencies: [
                "AppUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "LicensePlugin")
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                "CoreKit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "CoreKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AddAndEdit",
            dependencies: [
                "AppUI",
                "RemindScheduler",
                "CoreKit",
                "SwiftDataClient",
                "UserNotificationClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Detail",
            dependencies: [
                "AddAndEdit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "RemindScheduler",
            dependencies: [
                "AppUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "AppMacrosTests",
            dependencies: [
                "AppMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        .macro(
            name: "AppMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "SwiftDataClient",
            dependencies: [
                "CoreKit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "UserNotificationClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .plugin(
            name: "LicensePlugin",
            capability: .buildTool()
        )
    ]
)
