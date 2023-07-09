//
//  HomeView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/19/23.
//

import Bolt
import SwiftUI

struct HomeView: View {
  @AppStorage("publishableKey") var publishableKey = ""
  @State var environment = Bolt.Environment.sandbox

  init() {
    Bolt.ClientProperties.shared.environment = environment
  }
  
  var body: some View {
    NavigationView {
      List {
        NavigationLink {
          LoginView()
        } label: {
          Text("OTP login")
        }
        NavigationLink {
          TokenizerView()
        } label: {
          Text("Credit card tokenizer")
        }
        NavigationLink {
          CreateAccountView()
        } label: {
          Text("Create Bolt account checkbox")
        }
        NavigationLink {
          AnalyticsView()
        } label: {
          Text("Analytics")
        }
        Spacer()
        Text("Settings:")
        HStack {
          Text("Environment")
          Picker("Options", selection: $environment) {
            Text("Sandbox").tag(Bolt.Environment.sandbox)
            Text("Production").tag(Bolt.Environment.production)
          }
          .pickerStyle(.segmented)
          .onChange(of: environment) { newValue in
            Bolt.ClientProperties.shared.environment = environment
          }
        }
        VStack {
          TextField("Publishable key", text: $publishableKey) {
            Bolt.ClientProperties.shared.publishableKey = publishableKey
          }
          .textFieldStyle(RoundedBorderTextFieldStyle())
        }
      }
      .listStyle(.plain)
      .navigationTitle("Bolt iOS Example")
      .padding([.top])
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
