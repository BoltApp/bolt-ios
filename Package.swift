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
      url: "https://bolt-mobile-sdk.s3.us-west-2.amazonaws.com/1.0.3/Bolt.xcframework.zip",
      checksum: "1936c9ac770e314e157631f12b1b5bdc0c84abe5569777cadfb194d98ae79ae9"
    )
  ]
)
