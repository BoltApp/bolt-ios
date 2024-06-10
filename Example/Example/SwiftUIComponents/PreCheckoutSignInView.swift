//
//  PreCheckoutSignInView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct PreCheckoutSignInView: View {
  @AppStorage("preCheckoutEmail") private var email = ""
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
          Bolt.UI.SignInButton(context: .preCheckout) {
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
    .boltAuthorize(
      isAuthorizing: $isAuthorizing,
      email: email,
      context: .preCheckout,
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

struct PreCheckoutSignInView_Previews: PreviewProvider {
  static var previews: some View {
    PreCheckoutSignInView()
  }
}
