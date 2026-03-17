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
            url: "https://sdk.socure.com/socure-sdks/sigma-device/ios/socure-device-risk-4.8.1.zip",
            checksum: "7f9717cbf7f5739c93a466bc16d82197d4f7228354090984e9c29eb0f2a39c38"
        )
    ]
)
