//
//  SignedInStatusButtonView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct SignedInStatusButtonView: View {
  var body: some View {
    VStack {
      HStack {
        Bolt.UI.SignedInStatusButton { url in
          UIApplication.shared.open(url)
        }
        Spacer()
      }
      Spacer()
    }
    .padding()
  }
}

struct SignedInStatusButtonView_Previews: PreviewProvider {
  static var previews: some View {
    SignedInStatusButtonView()
  }
}
