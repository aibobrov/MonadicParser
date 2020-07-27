// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "MonadicParser",
    products: [
        .library(
            name: "MonadicParser",
            targets: ["MonadicParser"]
		)
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MonadicParser",
            dependencies: []
		),
        .testTarget(
            name: "MonadicParserTests",
            dependencies: ["MonadicParser"]
		)
    ]
)
