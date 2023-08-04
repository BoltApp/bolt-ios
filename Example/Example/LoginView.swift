//
//  ContentView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/30/23.
//

import Bolt
import SwiftUI

struct LoginView: View {
  @State var email = ""
  @State var authCode = ""
  @State var showOTPView = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("If a Bolt account exists with the email address, an OTP login view will be displayed after the email is entered.\n\nAccount can be created at ")
        Text(environment.accountUrl)
          .foregroundColor(.blue)
          .underline()
          .onTapGesture { UIApplication.shared.open(URL(string: environment.accountUrl)!) }
          .padding([.bottom])
        TextField(
          "Email",
          text: Binding(
            get: { email },
            set: { email = $0.whitespaceTrimmed }
          )
        ) {
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
      let url = Bolt.Login.getAuthorizationURL(email: email)!
      WebView(url: url) { authCode in
        self.authCode = authCode
        showOTPView = false
      }
    }
  }
}

private extension LoginView {
  var environment: Bolt.Environment {
    Bolt.ClientProperties.shared.environment
  }

  func detectBoltAccount() {
    // Call DetectAccount API - https://help.bolt.com/api-bolt/#tag/Account/operation/DetectAccount
    URLSession.shared.dataTask(with: detectBoltAccountUrlRequest) { data, response, _ in
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

  private var detectBoltAccountUrlRequest: URLRequest {
    var components = URLComponents()
    components.scheme = "https"
    components.host = environment.apiHost
    components.path = "/v1/account/exists"
    components.queryItems = [.init(name: "email", value: email)]

    // Usually the + character is not encoded into %2B since it's a valid character allowed in a query parameter (spaces are replaced with +).
    // In order to pass in an actual + sign, the specific character needs to be URL encoded.
    // This enables email containing a + sign to be encoded correctly.
    components.percentEncodedQuery = components.percentEncodedQuery?.addingPercentEncoding(
      withAllowedCharacters: .init(charactersIn: "+").inverted
    )

    var request = URLRequest(url: components.url!)
    request.setValue(Bolt.ClientProperties.shared.publishableKey, forHTTPHeaderField: "X-Publishable-Key")
    return request
  }
}

private extension Bolt.Environment {
  var accountUrl: String {
    switch self {
    case .sandbox: return "https://account-sandbox.bolt.com"
    case .production: return "https://account.bolt.com"
    @unknown default: fatalError()
    }
  }

  var apiHost: String {
    switch self {
    case .sandbox: return "api-sandbox.bolt.com"
    case .production: return "api.bolt.com"
    @unknown default: fatalError()
    }
  }
}

private extension String {
  var whitespaceTrimmed: String {
    replacingOccurrences(
      of: "\\s",
      with: "",
      options: .regularExpression
    )
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoginView()
    }
  }
}
