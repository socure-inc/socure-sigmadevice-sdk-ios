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
            targets: ["SigmaDeviceWrapper"])
    ],
    dependencies: [
        .package(url: "https://github.com/datatheorem/TrustKit", from: "2.0.0")
    ],
    targets: [
        .binaryTarget(
            name: "DeviceRisk",
            path: "Frameworks/DeviceRisk.xcframework"
        ),
        .target(
            name: "SigmaDeviceWrapper",
            dependencies: [
                .target(name: "DeviceRisk"),
                .product(name: "TrustKit", package: "TrustKit")
            ],
            path: "SigmaDeviceWrapper"
        ),
    ]
)
