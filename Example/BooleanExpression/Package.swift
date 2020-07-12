// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BooleanExpression",
    dependencies: [
		.package(name: "MonadicParser", url: "../..", .branch("develop")),
		.package(url: "https://github.com/apple/swift-argument-parser", .branch("master"))
    ],
    targets: [
        .target(
            name: "BooleanExpression",
			dependencies: [
                .product(name: "MonadicParser", package: "MonadicParser"),
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
			]
		),
        .testTarget(
            name: "BooleanExpressionTests",
            dependencies: ["BooleanExpression"]
		),
    ]
)
