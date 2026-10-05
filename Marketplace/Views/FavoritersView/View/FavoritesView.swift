//
//  FavoritersView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 14.09.2026.
//

import SwiftUI

struct FavoritesView: View {
    var columns = Array(repeating: GridItem(), count: 2)
    @EnvironmentObject var productViewModel: ProductViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVGrid(columns: columns) {
                    ForEach(productViewModel.products.filter { $0.isFavorite }) { item in
                        ProductCardView(product: item, onFavoriteTap:{
                            Task{
                                await productViewModel.toggleFavorite(productId: item.id!)
                            }
                        })
                    }
                }
            }
            .padding(.horizontal, 10)
            .background(.secondary.opacity(0.3))
            .shadow(color: .black.opacity(0.2), radius: 8, x: 5,y: 8)
            
        }
        .navigationTitle("Favorites")
        .task {
            await productViewModel.loadProducts()
        }
    }
}

#Preview {
    FavoritesView().environmentObject(ProductViewModel())
}
