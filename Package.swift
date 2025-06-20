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
            url: "https://sdk.socure.com/socure-sdks/sigma-device/ios/socure-device-risk-4.6.1.zip",
            checksum: "0202bf5e56813bcd87a2adb0ed37778ee9becc31416aee188e4adab32058cadb"
        )
    ]
)
