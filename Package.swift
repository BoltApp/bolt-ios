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
      url: "https://bolt-mobile-sdk.s3.us-west-2.amazonaws.com/1.1.0/Bolt.xcframework.zip",
      checksum: "2cf8732b401fe968f396e7b0f6b5c8b24f0105e473836a72ddbb19275e996fc4"
    )
  ]
)
