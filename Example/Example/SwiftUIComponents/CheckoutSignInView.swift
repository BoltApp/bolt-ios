//
//  CheckoutSignInView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct CheckoutSignInView: View {
  @AppStorage("checkoutEmail") private var email = ""
  @State private var isEmailValid = false
  @State private var hasAccount = false
  @State private var isAuthorizing = false
  @State private var resultText = ""

  var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: 16) {
        TextField("Email", text: $email)
          .textFieldStyle(.roundedBorder)
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
          .onChange(of: email) { _ in
            isEmailValid = EmailValidator.isValid(email)
            hasAccount = false
          }
        if hasAccount {
          Bolt.UI.SignInButton(context: .checkout) {
            isAuthorizing = true
          }
        }
        Button("Continue") {
          isAuthorizing = true
        }
        .buttonStyle(.borderedProminent)
        .disabled(!isEmailValid)
        Text(resultText)
        Spacer()
      }
      .padding()
    }
    .onAppear {
      isEmailValid = EmailValidator.isValid(email)
    }
    // Frame for boltAuthorize view modifier needs to be full screen size
    // so that the gray overlay can be displayed over the whole screen area
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .boltAuthorize(
      isAuthorizing: $isAuthorizing,
      email: email,
      context: .checkout,
      onAccountCheck: { accountExists in
        hasAccount = accountExists
      },
      completion: { result in
        switch result {
        case .completed(let authorizationCode):
          resultText = "Received auth code - \(authorizationCode)"
        case .failed(let error):
          resultText = "Error - \(error.localizedDescription)"
        case .canceled:
          resultText = "Canceled"
        }
      }
    )
  }
}

struct CheckoutSignInView_Previews: PreviewProvider {
  static var previews: some View {
    CheckoutSignInView()
  }
}
