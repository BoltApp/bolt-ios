//
//  HomeView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/19/23.
//

import SwiftUI

enum Environment: String, CaseIterable {
  case sandbox = "Sandbox"
  case production = "Production"
}

struct HomeView: View {
  @State var environment = Environment.sandbox
  
  var body: some View {
    NavigationView {
      List {
        NavigationLink {
          LoginView(environment: environment)
        } label: {
          Text("OTP login")
        }
        NavigationLink {
          TokenizerView(environment: environment)
        } label: {
          Text("Credit card tokenizer")
        }
        HStack {
          Text("Environment")
          Picker("Options", selection: $environment) {
            ForEach(Environment.allCases, id: \.self) { option in
              Text(option.rawValue).tag(option)
            }
          }
          .pickerStyle(.segmented)
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
