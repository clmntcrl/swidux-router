// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiduxRouter",
    products: [
        .library(name: "SwiduxRouter", targets: ["SwiduxRouter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/clmntcrl/swidux.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SwiduxRouter", dependencies: ["Swidux"]),
        .testTarget(name: "SwiduxRouterTests", dependencies: ["SwiduxRouter"]),
    ]
)
