//
//  SwiftUIComponentsView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct SwiftUIComponentsView: View {
  var body: some View {
    List {
      NavLink(view: PreCheckoutSignInView(), title: "Pre-checkout sign in")
      NavLink(view: CheckoutSignInView(), title: "Checkout sign in")
      NavLink(view: EmailInfoButtonView(), title: "Email info button")
      NavLink(view: SignedInStatusButtonView(), title: "Signed in status button")
      NavLink(view: AccountCreationCheckboxView(), title: "Account creation checkbox")
    }
    .listStyle(.plain)
    .padding([.top])
  }
}

struct SwiftUIComponentsView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIComponentsView()
  }
}
