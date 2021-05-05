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
                 .branch("main"))
    ],

    targets: [
        .target(name: "SwiftGenius",
                dependencies: ["JSONClient"],
                path: "Sources",
                resources: [
                    .copy("Sources/MockImplementation/JSON/get-account-200.json"),
                    .copy("Sources/MockImplementation/JSON/get-artist-songs-200.json"),
                    .copy("Sources/MockImplementation/JSON/get-referents-200.json"),
                    .copy("Sources/MockImplementation/JSON/get-songs-200.json"),
                    .copy("Sources/MockImplementation/JSON/get-annotations-200.json"),
                    .copy("Sources/MockImplementation/JSON/get-artists-200.json"),
                    .copy("Sources/MockImplementation/JSON/get-search-200.json"),
                    .copy("Sources/MockImplementation/JSON/get-web-pages-200.json")
                ]
        ),
        .testTarget(name: "SwiftGeniusTests",
                    dependencies: ["SwiftGenius"],
                    path: "Tests",
                    resources: [.copy("SampleFoo.json")])
    ]
)

