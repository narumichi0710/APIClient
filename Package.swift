// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "APIClient",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(name: "Core", targets: ["Core"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Core", dependencies: []),
        .testTarget(name: "CoreTests", dependencies: ["Core"]),
    ]
)
