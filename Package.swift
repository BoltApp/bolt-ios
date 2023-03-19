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
      exclude: ["Example"],
      url: "https://bolt-mobile-interview.s3.us-west-1.amazonaws.com/Bolt.xcframework.zip",
      checksum: "bde03998f4ff2afedc31bf036fd9178a113c6dedd759a2b024c0f7f7e1c859e4"
    )
  ]
)
