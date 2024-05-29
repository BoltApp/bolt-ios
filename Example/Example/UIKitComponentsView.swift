//
//  UIKitComponentsView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct UIKitComponentsView: View {
  var body: some View {
    List {
      UIKitNavLink(viewController: PreCheckoutSignInButtonViewController(), title: "Pre-checkout sign in")
      UIKitNavLink(viewController: CheckoutSignInButtonViewController(), title: "Checkout sign in")
      UIKitNavLink(viewController: EmailInfoButtonViewController(), title: "Email info button")
      UIKitNavLink(viewController: SignedInStatusButtonViewController(), title: "Signed in status button")
      UIKitNavLink(viewController: AccountCreationCheckboxViewController(), title: "Account creation checkbox")
    }
    .listStyle(.plain)
    .padding([.top])
  }
}

struct UIKitComponentsView_Previews: PreviewProvider {
  static var previews: some View {
    UIKitComponentsView()
  }
}
