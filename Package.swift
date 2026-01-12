// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Trevor",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(
            name: "Trevor",
            targets: ["Trevor"]
        ),
        .library(
            name: "TrevorLibrary",
            targets: ["TrevorLibrary"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TrevorLibrary",
            dependencies: [],
            resources: [
                .process("Resources/")
            ]
        ),
        .target(
            name: "Trevor",
            dependencies: ["TrevorLibrary"],
            resources: [
                .process("Resources/")
            ]
        ),
        .testTarget(
            name: "TrevorTests",
            dependencies: ["TrevorLibrary"]
        ),
    ]
)
