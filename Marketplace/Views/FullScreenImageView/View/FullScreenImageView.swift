//
//  FullScreenImageView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 09.10.2026.
//

import SwiftUI

struct FullScreenImageView: View {
    let uiImage: UIImage

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .ignoresSafeArea()

            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
        }
    }
}

//#Preview {
//    FullScreenImageView()
//}
