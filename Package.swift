// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SigmaDevice",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DeviceRisk",
            targets: ["DeviceRisk"])
    ],
    targets: [
        .binaryTarget(
            name: "DeviceRisk",
            url: "https://sdk.socure.com/socure-sdks/sigma-device/ios/socure-device-risk-4.9.0.zip",
            checksum: "2d9ba3d97d2c3fc807a47fd0df1c01bcb549e5d96e83de75b3b216b2c43a8739"
        )
    ]
)
