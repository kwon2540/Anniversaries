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
        .library(name: "License", targets: ["License"]),
        .library(name: "AppWidget", targets: ["AppWidget"]),
        .library(name: "SwiftDataClient", targets: ["SwiftDataClient"]),
        .library(name: "UserNotificationClient", targets: ["UserNotificationClient"]),
        .library(name: "WidgetCenterClient", targets: ["WidgetCenterClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.12.1"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "510.0.3"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "11.6.0"),
    ],
    targets: [
        .target(
            name: "AnniversariesKit",
            dependencies: [
                "AppFeature",
                "UserNotificationClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
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
                "WidgetCenterClient",
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
            name: "AppWidget",
            dependencies: [
                "CoreKit",
                "AppUI",
                "SwiftDataClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
                "WidgetCenterClient",
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
        .target(
            name: "WidgetCenterClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .macro(
            name: "AppMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .plugin(
            name: "LicensePlugin",
            capability: .buildTool()
        ),
        .testTarget(
            name: "AppMacrosTests",
            dependencies: [
                "AppMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "AddAndEditTests",
            dependencies: [
                "AddAndEdit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "DetailTests",
            dependencies: [
                "Detail",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: [
                "Home",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "LicenseTests",
            dependencies: [
                "License",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "RemindSchedulerTests",
            dependencies: [
                "RemindScheduler",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        )
    ]
)
