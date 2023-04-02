//
//  TokenizerView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/31/23.
//

import Bolt
import SwiftUI

struct TokenizerView: View {
  private let tokenizer = Bolt.CreditCardTokenizer()

  init(environment: Environment) {
    Bolt.ClientProperties.shared.environment = environment.asBoltEnvironment
  }

  @State var creditCardNumber = ""
  @State var cvvNumber = ""
  @State var tokenizeResult = ""
  @State var isLoading = false

  var body: some View {
    VStack(alignment: .leading) {
      Button("Prefill test card") {
        creditCardNumber = "4111111111111111"
        cvvNumber = "123"
      }
      .padding([.bottom])

      TextField("Credit Card Number", text: $creditCardNumber)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .keyboardType(.numberPad)

      TextField("CVV Number", text: $cvvNumber)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .keyboardType(.numberPad)
        .padding([.bottom])

      Button(action: {
        tokenize()
      }) {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .foregroundColor(.white)
        } else {
          Text("Tokenize")
            .foregroundColor(.white)
        }
      }
      .padding()
      .foregroundColor(.white)
      .background(Color.blue)
      .cornerRadius(5)

      Text(tokenizeResult)
        .padding([.top])

      Spacer()
    }
    .padding()
    .navigationTitle("Credit card tokenizer")
  }
}

private extension TokenizerView {
  func tokenize() {
    isLoading = true
    tokenizer.generateToken(cardNumber: creditCardNumber, cvv: cvvNumber) { result in
      isLoading = false
      switch result {
      case .success(let card):
        tokenizeResult = "Response - \(card)"
      case .failure(let error):
        tokenizeResult = "Error - \(error)"
      }
    }
  }
}

private extension Environment {
  var asBoltEnvironment: Bolt.Environment {
    switch self {
    case .sandbox: return .sandbox
    case .production: return .production
    }
  }
}

struct TokenizerView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TokenizerView(environment: .sandbox)
    }
  }
}
