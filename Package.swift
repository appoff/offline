// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "Offline",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Offline",
            targets: ["Offline"]),
    ],
    dependencies: [
        .package(url: "https://github.com/archivable/package.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Offline",
            dependencies: [
                .product(name: "Archivable", package: "package")],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Offline"],
            path: "Tests"),
    ]
)
