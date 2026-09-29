//
//  ContentView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 26.09.2026.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                MainView()
            } else {
                AuthView()
            }
        }
    }
}
