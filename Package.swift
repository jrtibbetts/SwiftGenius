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
        .package(url: "https://github.com/jrtibbetts/Stylobate.git",
                 .branch("main"))
    ],

    targets: [
        .target(name: "SwiftGenius",
                dependencies: ["Stylobate"],
                path: "Sources",
                resources: [
                    .copy("MockImplementation/JSON/get-account-200.json"),
                    .copy("MockImplementation/JSON/get-artist-songs-200.json"),
                    .copy("MockImplementation/JSON/get-referents-200.json"),
                    .copy("MockImplementation/JSON/get-songs-200.json"),
                    .copy("MockImplementation/JSON/get-annotations-200.json"),
                    .copy("MockImplementation/JSON/get-artists-200.json"),
                    .copy("MockImplementation/JSON/get-search-200.json"),
                    .copy("MockImplementation/JSON/get-web-pages-200.json")
                ]
        ),
        .testTarget(name: "SwiftGeniusTests",
                    dependencies: ["SwiftGenius"],
                    path: "Tests",
                    resources: [.copy("SampleFoo.json")])
    ]
)

