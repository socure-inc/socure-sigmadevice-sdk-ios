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
            url: "https://sdk.socure.com/socure-sdks/sigma-device/ios/socure-device-risk-4.4.0.zip",
            checksum: "6b0a9ac15252f1f2acee43683c2daa14dd09370a61b2f052539629a6633ef02f"
        )
    ]
)
