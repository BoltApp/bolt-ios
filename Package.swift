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
      url: "https://bolt-mobile-sdk.s3.us-west-2.amazonaws.com/1.0.1/Bolt.xcframework.zip",
      checksum: "143e451c84d396659ebfb156d3d6f5bd32df6c2b2b48b9f2b2ca2a001fe19c09"
    )
  ]
)
