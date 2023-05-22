# Bolt iOS SDK

The Bolt iOS SDK enables merchants to integrate their apps with Bolt Checkout.

## Getting SDK

The SDK is available as an `XCFramework` bundle that contains pre-built frameworks for iOS devices and simulators. Swift Package Manager and Cocoapods are supported package managers. Minimum iOS target version is 13.0.

### Swift Package Manager

1. Add package to Xcode project:
 - Go to File -> Add Packages
 - Enter the package URL - https://github.com/BoltApp/bolt-ios
 - Click on Add Package
2. Add framework to app target, if not automatically added:
 - Click on app project in project navigator
 - Select the app target
 - Select the General tab
 - Click on the + icon in Frameworks, Libraries and Embedded Content
 - Add Bolt module

### Cocoapods

1. Add `pod 'Bolt'` to your project's Podfile
2. Run `pod install`

## Initializing SDK

The SDK needs to be initialized with client properties before usage. The following properties can be specified:
1. __Publishable key__: the publicly viewable identifier used to identify a merchant division. This key is found in the Developer > API section of the Bolt Merchant Dashboard.
2. __Environment__: the Bolt server environment to use, e.g. `staging` or `production`.

### Initialization example

```swift
import Bolt

Bolt.ClientProperties.shared.publishableKey = "<key>"
Bolt.ClientProperties.shared.environment = .staging
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

## Handling Bolt user login

The Bolt SDK does not provide functionality for logging users into their existing Bolt account. However, this can be implemented directly in the app using your existing networking implementation and standard webviews. These are the steps required for enabling existing Bolt users to login:

### 1. Detect user account

First, we need to detect if a user has an existing Bolt account.
- In your checkout form, add a handler to the email address text field. This can be done using [UITextField.textFieldDidEndEditing(_:)](https://developer.apple.com/documentation/uikit/uitextfielddelegate/1619591-textfielddidendediting) in UIKit, or [TextField.onSubmit(of:_:)](https://developer.apple.com/documentation/swiftui/view/onsubmit(of:_:)) in SwiftUI.
- In this handler, call Bolt's [DetectAccount](https://help.bolt.com/api-bolt/#tag/Account/operation/DetectAccount) API with the email address and your merchant publishable key (can be found in Bolt Merchant Dashboard).
- If successful, the API will return a value indicating whether the email address is registered to a Bolt account:
```
{
    "has_bolt_account": true,
}
```
- If a Bolt account was detected, follow the next step to display the Bolt authorization page.

### 2. Display Bolt authorization page

The Bolt authorization page displays a prompt that asks users to input a one-time passcode (OTP) that is sent to their email or phone. After a user enters the OTP, the page redirects to a URL that contains an authorization code in the query parameters. This authorization code can then be sent to the merchant server to exchange for an OAuth access token. This can then be used to access Bolt Account APIs and access user information such as stored shipping addresses and credit cards.

- Create a `WKWebView` object and set the `navigationDelegate` property to an object that conforms to `WKNavigationDelegate`.
- Add an implementation for [WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:)](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455641-webview) that detects redirects and performs the appropriate action.
```swift
func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
) {
    guard let urlString = navigationAction.request.url?.absoluteString,
          let url = URL(string: urlString) else {
        return decisionHandler(.allow)
    }

    // NOTE: replace 'mobileapp' below with the prefix used for your app for Bolt login
    if urlString.hasPrefix("mobileapp://"), let range = urlString.range(of: "authorization_code=") {
        // We have a redirect with auth code in the query parameters
        let index = urlString.distance(from: urlString.startIndex, to: range.upperBound)
        let startIndex = urlString.index(urlString.startIndex, offsetBy: index)
        let authCode = String(urlString[startIndex...])
        decisionHandler(.allow)
        // Pass authCode to backend to exchange for OAuth access token
        // WebView can be dismissed at this point
    } else if urlString == parent.url.absoluteString {
        // This is the original URL request - open as normal
        decisionHandler(.allow)
    } else {
        // Open other links in the system browser, e.g. Terms of Use, Privacy Policy
        UIApplication.shared.open(url)
        decisionHandler(.cancel)
    }
}
```
- Load the URL below in the webview, filling in the publishable key and email address in the query parameters:
```
Production: https://account.bolt.com/hosted?email=email&publishableKey=publishableKey
Sandbox: https://account-sandbox.bolt.com/hosted?email=email&publishableKey=publishableKey
```
- Embed the `WKWebView` inside a `UIViewController` in UIKit or a `UIViewRepresentable` in SwiftUI and present it as a fullscreen modal.

This will show a page that looks like [this](https://user-images.githubusercontent.com/3752642/229895787-197b20b7-4187-4c88-9bdf-a17a8cb28896.png).

After the authorization code is received, pass it to your backend server which can use Bolt's [OAuthToken](https://help.bolt.com/api-bolt/#tag/OAuth/operation/OAuthToken) endpoint to exchange for an access token. The access token can be used with Bolt's [Account](https://help.bolt.com/api-embedded/#tag/Account) APIs to access the user's information.

## Example app

The [Example](./Example) folder contains an example app that demonstrates usage of the credit card tokenizer, Bolt user login, and account creation checkbox.
