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
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Trevor",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "TrevorTests",
            dependencies: ["Trevor"]
        ),
    ]
)
