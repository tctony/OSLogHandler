// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OSLogHandler",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3),
    ],
    products: [
        .library(
            name: "OSLogHandler",
            targets: ["OSLogHandler"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/tctony/SwiftLogFormatter.git", .exact("0.1.0")),
    ],
    targets: [
        .target(
            name: "OSLogHandler",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "LogFormatter", package: "SwiftLogFormatter"),
            ]
        ),
        .testTarget(
            name: "OSLogHandlerTests",
            dependencies: [
                "OSLogHandler",
            ]
        ),
    ]
)
