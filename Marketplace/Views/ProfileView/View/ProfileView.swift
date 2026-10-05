//
//  CartView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 14.09.2026.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack{
            ScrollView{
                if let user = authViewModel.user{
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.primary.opacity(0.5))
                        
                        //Text("test@gamil.com")
                        Text(user.email)
                            .foregroundStyle(Color(.blue))
                        
                        Text("Welcome")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Join date: \(user.createdAt.formatted(date: .long, time: .shortened))")
                        //Text("Join date: 12.12.2026")
                        
                        Button {
                            authViewModel.logout()
                        } label: {
                            Text("Log out")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.red))
                                .foregroundStyle(.background)
                                .cornerRadius(12)
                                .shadow(radius: 1)
                        }
                        .padding(.horizontal, 16)

                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
                } else {
                    Text("No user data available")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
            .background(.secondary.opacity(0.3))
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView().environmentObject(AuthViewModel())
}
