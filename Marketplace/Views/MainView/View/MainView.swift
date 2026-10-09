//
//  ContentView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 08.09.2026.
//

import SwiftUI
import FirebaseFirestore

struct MainView: View {
    var columns = Array(repeating: GridItem(), count: 2)
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var productViewModel = ProductViewModel()
    @State private var shouldRefresh = false

    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVGrid(columns: columns) {
                    ForEach(productViewModel.products) { item in
                        ProductCardView(product: item, onFavoriteTap:{
                                guard let productId = item.id else {
                                    return
                                }
                            Task{
                                await productViewModel.toggleFavorite(productId: productId)
                            }
                        })
                    }
                }
            }
            .padding(.horizontal, 10)
            .background(.secondary.opacity(0.3))
            .shadow(color: .black.opacity(0.2), radius: 8, x: 5,y: 8)
            .navigationTitle("Photo Gallery")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: FavoritesView().environmentObject(productViewModel)) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: AddPhotoView(shouldRefresh: $shouldRefresh)) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        authViewModel.logout()
                    } label: {
                        Text("Log out")
                    }
                }
            }
        }
        .onChange(of: shouldRefresh) {
            Task {
                await productViewModel.loadProducts()
                shouldRefresh = false
            }
        }
        .onAppear{
            Task{
                await productViewModel.loadProducts()
            }
        }
        .refreshable {
            Task{
                await productViewModel.loadProducts()
            }
        }
    }
}

#Preview {
    MainView()
}
