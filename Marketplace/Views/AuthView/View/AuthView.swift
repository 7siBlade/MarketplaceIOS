//
//  LoginView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 23.09.2026.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isRegisterMode = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text(isRegisterMode ? "Create Account" : "Login")
                    .font(.largeTitle)
                    .bold()
                
                if isRegisterMode {
                    TextField("Name", text: $name)
                        .font(.title2)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary, lineWidth: 2)
                        )
                        .padding(1)
                }
                
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .font(.title2)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 2)
                    )
                    .padding(1)
                
                    
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .font(.title2)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 2)
                    )
                    .padding(1)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Button {
                    Task {
                        if isRegisterMode {
                            await viewModel.register(
                                email: email,
                                password: password,
                                name: name
                            )
                        } else {
                            await viewModel.login(
                                email: email,
                                password: password
                            )
                        }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text(isRegisterMode ? "Register" : "Login")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    email.isEmpty ||
                    password.isEmpty ||
                    viewModel.isLoading
                )
                
                Button {
                    isRegisterMode.toggle()
                    viewModel.errorMessage = ""
                } label: {
                    Text(
                        isRegisterMode
                        ? "Already have an account? Login"
                        : "Don't have an account? Register"
                    )
                }
            }
            .padding()
            .navigationTitle("Authentication")
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
