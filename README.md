# Bolt iOS SDK

The Bolt iOS SDK enables merchants to integrate their apps with Bolt Checkout.

## Getting SDK

The SDK is available as an `XCFramework` bundle that contains pre-built frameworks for iOS devices and simulators. Swift Package Manager and Cocoapods are supported package managers. Minimum iOS target version is 14.0.

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
2. __Environment__: the Bolt server environment to use, e.g. `sandbox` or `production`.

In addition, a call needs to be made to register Bolt fonts with the system if Bolt UI components are being used.

### Initialization example

```swift
import Bolt

Bolt.ClientProperties.shared.publishableKey = "<key>"
Bolt.ClientProperties.shared.environment = .staging
Bolt.UI.registerFonts()
```

## Bolt UI components

### Email info button

<img src="https://github.com/BoltApp/bolt-ios/assets/3752642/05b17856-dceb-4407-aa1e-2d6b17dc2dad" width="300"> <img src="https://github.com/BoltApp/bolt-ios/assets/3752642/22c18f89-ba55-46d2-b6ac-0f9649e418c2" width="300">

The email info button is a text button that when tapped, displays a bottom sheet with info on how email address is used by Bolt during the authorization process. Links in the bottom sheet are handled by a closure or delegate passed into the button.

#### SwiftUI

```swift
Bolt.UI.EmailInfoButton { url in
  UIApplication.shared.open(url)
}
```

#### UIKit

```swift
let button = Bolt.UI.EmailInfoButtonViewController()
button.delegate = self

...

extension ParentViewController: BoltEmailInfoButtonViewControllerDelegate {
  func didTapLink(_ sender: Any, url: URL) {
    UIApplication.shared.open(url)
  }
}
```

### Sign-in button

<img src="https://github.com/BoltApp/bolt-ios/assets/3752642/33c66d11-6811-4532-bb07-99474f0b6fff" width="300"> <img src="https://github.com/BoltApp/bolt-ios/assets/3752642/0c2bda4b-4dd6-4b42-a127-9075b7980f7a" width="300">

The sign-in button can be used to offer existing Bolt users the option to sign in. at multiple points during the shopping journey, including during account registration, account login, and checkout. The button will either have the title as 'Passwordless Sign In' for pre-checkout contexts, or 'Autofill' for the checkout context. The button offers shoppers the option to sign into Bolt if the authorization screen was previously dismissed. They can be placed adjacent to email address input fields.

The button should only be displayed when the shopper’s entered email address is recognized by Bolt during the authorization process.

#### SwiftUI

```swift
// Pre-checkout
Bolt.UI.SignInButton(context: .preCheckout) {
  // Start Bolt authorization process
}

// Checkout
Bolt.UI.SignInButton(context: .checkout) {
  // Start Bolt authorization process
}

...

extension PreCheckoutSignInViewController: BoltSignInButtonViewControllerDelegate {
  func signInButtonViewControllerDidTapButton(
    _ controller: Bolt.UI.SignInButtonViewController
  ) {
    startAuthorization()
  }
}
```

#### UIKit

```swift
// Pre-checkout
let button = Bolt.UI.SignInButtonViewController(context: .preCheckout)
button.delegate = self

// Checkout
let button = Bolt.UI.SignInButtonViewController(context: .checkout)
button.delegate = self
...

extension ParentViewController: BoltSignInButtonViewControllerDelegate {
  func signInButtonViewControllerDidTapButton(
    _ controller: Bolt.UI.SignInButtonViewController
  ) {
    // Start Bolt authorization process
  }
}
```

### Signed-in status button

<img src="https://github.com/BoltApp/bolt-ios/assets/3752642/6acb36c2-562b-4517-8f71-dc3d95443c49" width="300"> <img src="https://github.com/BoltApp/bolt-ios/assets/3752642/b4586e80-8613-4688-8ca1-5fa1f13bf085" width="300">

The signed-in status button indicates to shoppers that they have signed into Bolt. When the button is tapped, a bottom sheet is displayed with information about the benefits of having a Bolt account. Links in the bottom sheet are handled by a closure or delegate passed into the button. The button should only be displayed for users that have signed into Bolt.

#### SwiftUI

```swift
Bolt.UI.SignedInStatusButton { url in
  UIApplication.shared.open(url)
}
```

#### UIKit

```swift
let button = Bolt.UI.SignedInStatusButtonViewController()
button.delegate = self

...

extension ParentViewController: BoltSignedInStatusButtonViewControllerDelegate {
  func didTapLink(_ sender: Any, url: URL) {
    UIApplication.shared.open(url)
  }
}
```

### Account creation checkbox

<img src="https://github.com/BoltApp/bolt-ios/assets/3752642/044b0308-09ce-4584-8a8f-77ffa6bd2355" width="300"> <img src="https://github.com/BoltApp/bolt-ios/assets/3752642/22ec571e-10c3-4d89-8b52-ccfb54bea4b0" width="300">

The account creation checkbox enables shoppers to opt-in or opt-out of creating a Bolt Account. This can be displayed in the final checkout screen before shoppers place an order. The value of the checkbox can be sent to the Bolt API when the user finalizes the order. This should only be displayed for users that have not already signed into Bolt.

#### SwiftUI

```swift
Bolt.UI.AccountCheckbox(
  merchantName: "Merchant",
  isChecked: true,
  onCheckboxTap: { isChecked in
    self.isChecked = isChecked
  },
  onLinkTap: { url in
    UIApplication.shared.open(url)
  }
)
```

#### UIKit

```swift
let accountCheckbox = Bolt.UI.AccountCheckboxViewController(
  merchantName: "Merchant name",
  isChecked: true
)
accountCheckbox.delegate = self

...

extension AccountCreationCheckboxViewController: BoltAccountCheckboxViewControllerDelegate {
  func didTapLink(_ sender: Any, url: URL) {
    UIApplication.shared.open(url)
  }

  func accountCheckboxViewController(
    _ controller: Bolt.UI.AccountCheckboxViewController,
    didChangeToggle isChecked: Bool
  ) {
    self.isChecked = isChecked
  }
}
```

## Bolt user authorization

<img src="https://github.com/BoltApp/bolt-ios/assets/3752642/5f69aa61-aaa9-4d03-a72c-9bc05b7fa1fc" width="300"> <img src="https://github.com/BoltApp/bolt-ios/assets/3752642/5b2d578b-ccd2-448c-9d02-fc5e4eea3cb7" width="300">

The Bolt authorization process displays a prompt that asks users to input a one-time passcode (OTP) that is sent to their email or phone. After a user enters the OTP, the page redirects to a URL that contains an authorization code in the query parameters. This authorization code can then be sent to the merchant server to exchange for an OAuth access token. This can then be used to access Bolt Account APIs and access user information such as stored shipping addresses and credit cards.

The authorization process is slightly different, depending on the context:

- In the `checkout` context, the function checks if the user has an existing Bolt account. A loading view and gray background is displayed over the parent screen during this check. If an account is found, a sign-in screen is displayed. If no account is found, an `AuthorizationError.accountDoesNotExist` error is returned.
- In other contexts, the function either presents a sign-in screen if the user has an account or a registration screen if they do not.

The function has an `onAccountCheck` closure that is called with a value indicating if the user has a Bolt account. This can be used to show the Bolt Sign-in button to enable the user to sign in if they cancel the current authorization process.

After the authorization code is received, pass it to your backend server which can use Bolt's [OAuthToken](https://help.bolt.com/api-bolt/#tag/OAuth/operation/OAuthToken) endpoint to exchange for an access token. The access token can be used with Bolt's [Account](https://help.bolt.com/api-embedded/#tag/Account) APIs to access the user's information.

#### SwiftUI

In SwiftUI, a view modifier is provided to handle the authorization process. This is responsible for overlaying the loading screen on the parent view and presenting the OTP entry screen.

```swift
  @State private var isAuthorizing = false

  VStack() {
    // Parent view
    Button("Sign in") {
      isAuthorizing = true
    }
  }
  .boltAuthorize(
    isAuthorizing: $isAuthorizing,
    email: "email@domain.com",
    context: .preCheckout,
    onAccountCheck: { accountExists in
      // Show or hide Bolt Sign-in button
    },
    completion: { result in
      switch result {
      case .completed(let authorizationCode):
        // Pass authorization code to server
      case .failed(let error):
        // Error occurred
      case .canceled:
        // User canceled flow
    }
  }
)
```

#### UIKit

```swift
func startAuthorization() {
  Bolt.Login.startAuthorization(
    email: "email@domain.com",
    parentViewController: self,
    context: .preCheckout,
    onAccountCheck: { accountExists in
      // Show or hide Bolt Sign-in button
    },
    completion: { result in
      switch result {
      case .completed(let authorizationCode):
        // Pass authorization code to server
      case .failed(let error):
        // Error occurred
      case .canceled:
        // User canceled flow
      }
    }
  )
}
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

## Implementing checkout analytics

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

## Example app

The [Example](./Example) folder contains an example app that demonstrates usage of the Bolt iOS SDK.
