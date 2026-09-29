//
//  FavoritesService.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 27.09.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FavoritesService {

    private let db = Firestore.firestore()

    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    func addToFavorites(productId: String) async throws {

        guard let userId else {
            throw AuthError.userNotFound
        }

        try await db
            .collection("users")
            .document(userId)
            .collection("favorites")
            .document(productId)
            .setData([
                "productId": productId
            ])
    }

    func removeFromFavorites(productId: String) async throws {

        guard let userId else {
            throw AuthError.userNotFound
        }

        try await db
            .collection("users")
            .document(userId)
            .collection("favorites")
            .document(productId)
            .delete()
    }

    func getFavorites() async throws -> Set<String> {

        guard let userId else {
            throw AuthError.userNotFound
        }

        let snapshot = try await db
            .collection("users")
            .document(userId)
            .collection("favorites")
            .getDocuments()

        return Set(snapshot.documents.map { $0.documentID })
    }
}

enum AuthError: Error {
    case userNotFound
}
