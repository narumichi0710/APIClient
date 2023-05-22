// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "APIClient",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(name: "APIClient", targets: ["APIClient"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "APIClient", dependencies: []),
        .testTarget(name: "APIClientTests", dependencies: ["APIClient"]),
    ]
)
