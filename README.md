# Bolt iOS SDK

The Bolt iOS SDK enables merchants to integrate their apps with Bolt Checkout.

## Getting SDK using Swift Package Manager

The SDK is available as an `XCFramework` bundle that contains pre-built frameworks for iOS devices and simulators.
Minimum iOS target version is 13.0.
The framework can be added by following these steps:

1. Add package to Xcode project:
 - Go to File -> Add Packages
 - Enter the package [URL](https://github.com/BoltApp/bolt-ios)
 - Click on Add Package
2. Add framework to app target, if not automatically added:
 - Click on app project in project navigator
 - Select the app target
 - Select the General tab
 - Click on the + icon in Frameworks, Libraries and Embedded Content
 - Add Bolt module

## Initializing SDK

The SDK needs to be initialized with client properties before usage. The following properties can be specified:
1. __Publishable key__: the publicly viewable identifier used to identify a merchant division. This key is found in the Developer > API section of the Bolt Merchant Dashboard.
2. __Environment__: the Bolt server environment to use, e.g. `staging` or `production`.

### Initialization example

```swift
import Bolt

var clientProperties = Bolt.ClientProperties.shared

clientProperties.publishableKey = "<key>"
clientProperties.environment = .staging
```

## Credit card tokenizer

The credit card tokenizer provides a method to collect and store credit card information in a PCI compliant manner. Internally, the SDK encrypts card and token information with a locally generated client public/private key pair and server public key.

 The token can be forwarded to the merchant server which can use it to charge a credit card using the Bolt merchant [authorize](https://help.bolt.com/api-bolt/#tag/Transactions/operation/MerchantAuthorize) endpoint.

### Usage

The tokenizer function accepts a credit card number and card verification value (CVV). In the case of a successful response from the server, a newly generated card token value is returned, which represents the stored card.

```swift
let tokenizer = Bolt.CreditCardTokenizer()
tokenizer.generateToken(cardNumber: "4111111111111111", cvv: "123") { result in
    switch result {
    case let .success(tokenizedCard):
        print(tokenizedCard)
    case let .failure(error):
        print(error)
    }
}
```

The card number `4111 1111 1111 1111` can be used with any CVV in the staging environment to get a successful tokenizer response.

### Response example

```swift
CreditCardToken(
    token: "7dfc9c8c3e69a383da7b203e5b685e72f242ed90298d3e2f3426fd010c8e6219",
    tokenExpiry: 1671140825305, // 15 minutes from time of creation
    last4: "1111",
    bin: "411111",
    network: "visa"
)
```

## Example app

The [Example](./Example) folder contains an example app that demonstrates usage of the SDK.
