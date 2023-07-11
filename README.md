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
1. __Publishable key__: the publicly viewable identifier used to identify a merchant division. This key is found in the Administration -> Developers -> API section of the Bolt Merchant Dashboard.
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

<img src="https://github.com/BoltApp/bolt-ios/assets/3752642/aa2fd190-a1bb-41c8-a5e0-84418ad0439f" width="300">
<p>&nbsp;</p>

These are the steps required for enabling existing Bolt users to login:

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
- Get the Bolt authorization URL and load it in the webview. The URL can be force unwrapped safely, it will only return nil if the publishable key was not set in the Initialization step.
```swift
let url = Bolt.Login.getAuthorizationURL(email: "user@email.com")!
webView.load(.init(url: url))
```
- Embed the `WKWebView` inside a `UIViewController` in UIKit or a `UIViewRepresentable` in SwiftUI and present it as a fullscreen modal. A fullscreen modal should be used to ensure that there is space to show the keyboard and any error messages in the webpage.

After the authorization code is received, pass it to your backend server which can use Bolt's [OAuthToken](https://help.bolt.com/api-bolt/#tag/OAuth/operation/OAuthToken) endpoint to exchange for an access token. The access token can be used with Bolt's [Account](https://help.bolt.com/api-embedded/#tag/Account) APIs to access the user's information.

## Implementing checkout analytics (optional)

Merchants can invoke an analytics method that tracks checkout funnel events. This is an optional step and is useful for gathering data on the user's shopping journey from checkout to payment. There are several predefined events that can be tracked at specific points in the checkout flow. Example call to make when Checkout button is tapped from the shopping cart:

```swift
Bolt.Analytics.log(.checkoutButtonTapped)
```

### Event listing

Events are defined in the `Bolt.Analytics.Event` enum:

| Event name | When to track event |
| --- | --- |
| checkoutButtonTapped | Checkout button is tapped from shopping cart |
| checkoutLoadSuccess | Initial checkout screen is fully loaded |
| checkoutLoadError | An error occurs that prevents checkout screen from being loaded |
| shippingAddressEntryBegan | User began inputting information on shipping address |
| shippingDetailsFullyEntered | User entered all fields on the shipping address screen |
| shippingContinueButtonTapped | User tapped button to continue checkout process on the shipping address screen |
| shippingMethodSelected | User selects or switches shipping method |
| boltAccountExistenceCheckRequested | Bolt DetectAccount API was called to check if Bolt account exists |
| boltAccountExistenceCheckReceived | Bolt DetectAccount API response was received |
| boltAccountCreationCheckboxTapped | User checked Bolt account creation checkbox |
| boltLoginScreenDisplayed | OTP prompt is displayed for user login |
| boltLoginScreenClosed | OTP prompt is closed |
| boltLogOutButtonTapped | User taps button to log out of Bolt account |
| paymentDetailsFullyEntered | User entered all fields on payment screen or selects a saved payment method |
| paymentMethodSelected | User selects a new payment method |
| paymentButtonTapped | User tapped payment button |
| paymentSuccessful | Order was successful placed |
| paymentFailed | Order failed at payment step |

### Adding custom data

Custom properties can be included in all events or in specific events. These properties are key value pairs where the key is a `String` and value is any type that conforms to `Encodable`. For adding to all events, use the `setCommonProperties` function. For example, to add a property that represents whether the user is logged into the merchant account:

```swift
Bolt.Analytics.setCommonProperties(["merchantLoggedIn": true])
```

To add a property to a specific event, use the `additionalProperties` parameter in the `log` function:

```swift
Bolt.Analytics.log(.checkoutButtonTapped, ["merchantLoggedIn": true])
```

## Account creation checkbox

![account creation](https://github.com/BoltApp/bolt-ios/assets/3752642/2ef8e3e8-b584-484d-be02-f5c2975073bc)

A checkbox can be added to the checkout screen to enable users to create a Bolt account when they place the order. In order to add images inline with the text, `NSAttributedString` along with `NSTextAttachment` can be used. A SwiftUI implementation example is provided in [CreateAccountView.swift](./Example/Example/CreateAccountView.swift). It uses `UIViewRepresentable` to wrap a `UILabel` that is set with an attributed string containing the text and Bolt logo.

## Example app

The [Example](./Example) folder contains an example app that demonstrates usage of the credit card tokenizer, Bolt user login, checkout analytics, and account creation checkbox.
