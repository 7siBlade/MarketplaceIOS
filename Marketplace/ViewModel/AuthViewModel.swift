//
//  AuthViewModel.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 26.09.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: AppUser?
    
    @Published var isAuthenticated = false
    @Published var isLoading = true
    @Published var errorMessage = ""
    
    private let authService = AuthService()
    private let db = Firestore.firestore()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthListener()
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    private func setupAuthListener() {
        authStateListener = Auth.auth()
            .addStateDidChangeListener { [weak self] _, firebaseUser in
                Task { @MainActor in
                    if let firebaseUser = firebaseUser {
                        self?.isAuthenticated = true
                        await self?.fetchUserData(uid: firebaseUser.uid)
                    } else {
                        self?.isAuthenticated = false
                        self?.user = nil
                        self?.isLoading = false
                    }
                }
            }
    }
    
    func fetchUserData(uid: String) async {
        isLoading = true
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            self.user = try snapshot.data(as: AppUser.self)
        } catch {
            self.errorMessage = "Erroe loading profile: \(error.localizedDescription)"
        }
        self.isLoading = false
    }
    
    func register(email: String, password: String, name: String) async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        
        do {
            let firebaseUser = try await authService.register(email: email, password: password)
            try await createUserDocument(user: firebaseUser, nameUser: name)
            
            await fetchUserData(uid: firebaseUser.uid)
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription; isLoading = false }
        }
    }
    
    func login(email: String, password: String) async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        do {
            _ = try await authService.login(email: email, password: password)
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription; isLoading = false }
        }
    }
    
    func logout() {
        do {
            try authService.logout()
            self.user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func createUserDocument(user: User, nameUser: String) async throws {
        try await db.collection("users").document(user.uid).setData([
            "uid": user.uid,
            "email": user.email ?? "",
            "name": nameUser,
            "createdAt": FieldValue.serverTimestamp()
        ])
    }
}
