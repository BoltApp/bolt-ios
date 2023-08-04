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
      url: "https://bolt-mobile-sdk.s3.us-west-2.amazonaws.com/1.0.2/Bolt.xcframework.zip",
      checksum: "8d23f7b923aa354c5df7e83a3c97a95c9248aaacf1dc470d1727f17a310f1490"
    )
  ]
)
