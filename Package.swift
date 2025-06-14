// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MeadowDream",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MeadowDream",
            targets: ["MeadowDream"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MeadowDream",
            dependencies: []),
        .testTarget(
            name: "MeadowDreamTests",
            dependencies: ["MeadowDream"]),
    ]
) 