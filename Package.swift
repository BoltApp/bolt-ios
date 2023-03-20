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
      url: "https://bolt-mobile-sdk.s3.us-west-2.amazonaws.com/Bolt.xcframework.zip",
      checksum: "834ee84096ad69aff3a7f7af8f414623e913a216985f74fe705514c8be8174ce"
    )
  ]
)
