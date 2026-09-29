//
//  ContentView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 08.09.2026.
//

import SwiftUI
import FirebaseFirestore

struct MainView: View {
    //@FirestoreQuery(collectionPath: "shop") var items: [Product]
    var columns = Array(repeating: GridItem(), count: 2)
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var productViewModel = ProductViewModel()

    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVGrid(columns: columns) {
                    ForEach(productViewModel.products) { item in
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
            
            Button {
                authViewModel.logout()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .foregroundStyle(.primary)
                    .clipShape(Circle())
            }
            .navigationTitle("Marketplace")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: FavoritesView().environmentObject(productViewModel)) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CartView()) {
                        Image(systemName: "cart.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }.task {
            await productViewModel.loadProducts()
        }
    }
}

#Preview {
    MainView()
}
