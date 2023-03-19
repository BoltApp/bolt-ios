//
//  ContentView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/19/23.
//

import Bolt
import SwiftUI

struct ContentView: View {
  private let tokenizer = Bolt.CreditCardTokenizer()
  
  init() {
    Bolt.ClientProperties.shared.environment = .staging
  }
  
  var body: some View {
    Button("Tokenize") {
      tokenize()
    }
  }

  private func tokenize() {
    Bolt.ClientProperties.shared.environment = .staging
    tokenizer.generateToken(cardNumber: "4111111111111111", cvv: "123") { result in
      switch result {
      case .success(let card):
        print(card)
      case .failure(let error):
        print(error)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
