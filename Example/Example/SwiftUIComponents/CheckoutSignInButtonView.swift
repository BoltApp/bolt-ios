//
//  CheckoutSignInButtonView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct CheckoutSignInButtonView: View {
  @AppStorage("checkoutEmail") private var email = ""
  @State private var isAuthorizing = false
  @State private var resultText = ""

  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        TextField("Email", text: $email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
        Bolt.UI.SignInButton(context: .checkout) {
          isAuthorizing = true
        }
        Text(resultText)
          .padding(8)
        Spacer()
      }
      .padding()
    }
    // Frame for boltAuthorize view modifier needs to be full screen size
    // so that the gray overlay can be displayed over the whole screen area
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .boltAuthorize(
      isAuthorizing: $isAuthorizing,
      email: email,
      context: .checkout
    ) { result in
      switch result {
      case .completed(let authorizationCode):
        resultText = "Received auth code - \(authorizationCode)"
      case .failed(let error):
        resultText = "Error - \(error.localizedDescription)"
      case .canceled:
        resultText = "Canceled"
      }
    }
  }
}

struct CheckoutSignInButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CheckoutSignInButtonView()
  }
}
