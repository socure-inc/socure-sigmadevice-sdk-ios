// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "SigmaDevice",
    platforms: [
           .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SigmaDevice",
            targets: ["SigmaDeviceWrapper"]),
        .library(
            name: "SigmaDeviceWithoutTrustKit",
            targets: ["DeviceRisk"])
    ],
    targets: [
        .binaryTarget(
            name: "DeviceRisk",
            path: "Framework/DeviceRisk.xcframework"
        ),
        .binaryTarget(
            name: "TrustKit",
            path: "Framework/TrustKit.xcframework"
        ),
        .target(
            name: "SigmaDeviceWrapper",
            dependencies: [
                .target(name: "DeviceRisk"),
                .target(name: "TrustKit")
            ],
            path: "SigmaDeviceWrapper"
        ),
    ]
)
