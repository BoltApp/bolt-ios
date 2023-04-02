//
//  ContentView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/30/23.
//

import SwiftUI

struct LoginView: View {
  let environment: Environment

  @AppStorage("publishableKey") var publishableKey = ""
  @State var email = ""
  @State var authCode = ""
  @State var showOTPView = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("Enter publishable key from Bolt Merchant Dashboard and Bolt user email address.\n\nIf a Bolt account exists with the email address, an OTP login view will be displayed after the email is entered.\n\nAccount can be created at ")
        Text(environment.accountUrl)
          .foregroundColor(.blue)
          .underline()
          .onTapGesture { UIApplication.shared.open(URL(string: environment.accountUrl)!) }
          .padding([.bottom])
        TextField("Publishable key", text: $publishableKey)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("Email", text: $email) {
          detectBoltAccount()
        }
        .keyboardType(.emailAddress)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        if !authCode.isEmpty {
          Text("Auth code from OTP login - \(authCode)")
        }

        Spacer()
      }
    }
    .padding()
    .navigationTitle("OTP login")
    .sheet(isPresented: $showOTPView) {
      let url = URL(string: "\(environment.accountUrl)/hosted?email=\(email)&publishableKey=\(publishableKey)")!
      WebView(url: url) { authCode in
        self.authCode = authCode
        showOTPView = false
      }
    }
  }
}

private extension LoginView {
  func detectBoltAccount() {
    // Call DetectAccount API - https://help.bolt.com/api-bolt/#tag/Account/operation/DetectAccount
    let url = URL(string: "\(environment.apiUrl)/v1/account/exists?email=\(email)")!
    URLSession.shared.dataTask(with: url) { data, response, _ in
      guard let data = data,
            let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let hasBoltAccount = responseJSON["has_bolt_account"] as? Int,
            hasBoltAccount == 1 else {
        return
      }

      // Bolt account exists, show OTP view for authorization
      showOTPView = true
    }
    .resume()
  }
}

private extension Environment {
  var accountUrl: String {
    switch self {
    case .sandbox: return "https://account-sandbox.bolt.com"
    case .production: return "https://account.bolt.com"
    }
  }

  var apiUrl: String {
    switch self {
    case .sandbox: return "https://api-sandbox.bolt.com"
    case .production: return "https://api.bolt.com"
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoginView(environment: .sandbox)
    }
  }
}
