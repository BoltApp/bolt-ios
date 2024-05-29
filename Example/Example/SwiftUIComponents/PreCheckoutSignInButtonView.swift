//
//  PreCheckoutSignInButtonView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct PreCheckoutSignInButtonView: View {
  @AppStorage("preCheckoutEmail") private var email = ""
  @State private var isAuthorizing = false
  @State private var resultText = ""

  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        TextField("Email", text: $email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
        Bolt.UI.SignInButton(context: .preCheckout) {
          isAuthorizing = true
        }
        Text(resultText)
          .padding(8)
        Spacer()
      }
      .padding()
    }
    .boltAuthorize(
      isAuthorizing: $isAuthorizing,
      email: email,
      context: .preCheckout
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

struct PreCheckoutSignInButtonView_Previews: PreviewProvider {
  static var previews: some View {
    PreCheckoutSignInButtonView()
  }
}
