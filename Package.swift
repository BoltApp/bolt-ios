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
      url: "https://bolt-mobile-sdk.s3.us-west-2.amazonaws.com/0.3.0/Bolt.xcframework.zip",
      checksum: "df68e97a306dc8a26c0f7e3fe0ade3b9d31d7168950b9185de83e58c0d83063c"
    )
  ]
)
