//
//  ProductCardView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 14.09.2026.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    let onFavoriteTap: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack(alignment: .bottom) {
                ZStack(alignment: .topTrailing) {
                    if let uiImage = ImageBase64().decodeBase64ToImage(product.image) {
                        NavigationLink() {
                            FullScreenImageView(uiImage: uiImage)
                        } label: {
                            CardImageView(
                                uiImage: uiImage,
                                width: size.width,
                                height: size.height
                            )
                        }
                    } else {
                        ProgressView()
                            .frame(width: size.width, height: size.height)
                    }

                    Button {
                        onFavoriteTap()
                    } label: {
                        Image(systemName: "heart.fill")
                            .padding(10)
                            .foregroundStyle(product.isFavorite ? .red : .white)
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding()
                    }
                    .buttonStyle(.borderless)
                }
                VStack(alignment: .leading){
                    Text(product.name)
                        .titleFont()
                        .lineLimit(1)
                    Text("By: \(product.author)")
                        .subTitleFont()
                        .lineLimit(1)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background.opacity(0.5))
                .cornerRadius(10)
                .padding(10)
            }
        }
        .frame(height: UIScreen.main.bounds.width * 0.7)
        //.padding(10)
    }
}

#Preview {
    MainView()
}
