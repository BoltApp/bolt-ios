// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Bolt",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "Bolt",
      targets: ["Bolt"]
    )
  ],
  dependencies: [],
  targets: [
    .binaryTarget(
      name: "Bolt",
      url: "https://bolt-mobile-sdk.s3.us-west-2.amazonaws.com/1.0.0/Bolt.xcframework.zip",
      checksum: "21fe63350f246e0440285a976d7faca4dd0ed361800a1d939b13a8b5fa35c74e"
    )
  ]
)
