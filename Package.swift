// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SigmaDevice",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "DeviceRisk",
            targets: ["DeviceRisk"])
    ],
    targets: [
        .binaryTarget(
            name: "DeviceRisk",
            url: "https://sdk.socure.com/socure-sdks/sigma-device/ios/socure-device-risk-4.11.1.zip",
            checksum: "39fb81706a5a89d7572f13664c2074c8b25c630a304d499147773694fb5249a7"
        )
    ]
)
