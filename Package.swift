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
            targets: ["SwiftGenius"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/jrtibbetts/JSONClient.git",
                 .branch("main")),
        .package(url: "https://github.com/mxcl/PromiseKit.git",
                 .upToNextMajor(from: "6.12.0"))
    ],

    targets: [
        .target(name: "SwiftGenius",
                dependencies: ["JSONClient"],
                path: "Sources"
        ),
        .testTarget(name: "SwiftGeniusTests",
                    dependencies: ["SwiftGenius"],
                    path: "Tests",
                    resources: [.copy("SampleFoo.json")])
    ]
)

