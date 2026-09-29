//
//  ProductService.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 27.09.2026.
//

import Foundation
import FirebaseFirestore

final class ProductService {
    private let db = Firestore.firestore()

    func fetchProducts() async throws -> [Product] {
        let snapshot = try await db
            .collection("shop")
            .getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Product.self)
        }
    }
}
