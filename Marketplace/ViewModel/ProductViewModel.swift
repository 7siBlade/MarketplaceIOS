//
//  ViewModel.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 27.09.2026.
//

import Foundation
import Combine

@MainActor
final class ProductViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    private let productService = ProductService()
    private let favoritesService = FavoritesService()

    func loadProducts() async {
        isLoading = true
        errorMessage = ""
        do {
            products = try await productService.fetchProducts()
            // После загрузки товаров
            // загружаем избранное
            await loadFavorites()
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
        }
        isLoading = false
    }

    func loadFavorites() async {
        do {
            let favoriteIds =
                try await favoritesService.getFavorites()
            for index in products.indices {
                products[index].isFavorite =
                favoriteIds.contains(products[index].id!)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite(productId: String) async {
        guard let index = products.firstIndex(
            where: { $0.id == productId }
        ) else {
            return
        }

        let currentValue = products[index].isFavorite

        do {
            if currentValue {
                try await favoritesService.removeFromFavorites(
                    productId: productId
                )
            } else {
                try await favoritesService.addToFavorites(
                    productId: productId
                )
            }
            products[index].isFavorite.toggle()

        } catch {
            errorMessage = error.localizedDescription
            print("Favorite error: \(error)")
        }
    }
}
