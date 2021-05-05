// swift-tools-version:5.3
import PackageDescription

let pkg = Package(
    name: "SwiftGenius",

    platforms: [
        .iOS(.v14)
    ],

    products: [
        .library(
            name: "SwiftGenius",
            targets: ["Sources"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/jrtibbetts/JSONClient.git",
                 .branch("main")),
    ],

    targets: [
        .target(name: "Sources",
                dependencies: ["JSONClient"],
                path: "Sources"
        ),
        .testTarget(name: "Tests",
                    dependencies: ["Sources"],
                    path: "Tests"
                    )
    ]
)

