//
//  EmailInfoButtonView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct EmailInfoButtonView: View {
  @State private var email = ""

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      TextField("Email", text: $email)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      Bolt.UI.EmailInfoButton { url in
        UIApplication.shared.open(url)
      }
      .padding(.leading, 8)
      Spacer()
    }
    .padding()
  }
}

struct EmailInfoButtonView_Previews: PreviewProvider {
  static var previews: some View {
    EmailInfoButtonView()
  }
}
