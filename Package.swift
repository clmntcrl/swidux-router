// swift-tools-version:4.2

import PackageDescription

// Note: SwiftPM support is broken until we can add dependency on UIKit.

let package = Package(
    name: "SwiduxRouter",
    products: [
        .library(
            name: "SwiduxRouter",
            targets: ["SwiduxRouter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/clmntcrl/swidux.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "SwiduxRouter",
            dependencies: ["Swidux"]),
        .testTarget(
            name: "SwiduxRouterTests",
            dependencies: ["Swidux", "SwiduxRouter"]),
    ]
)
