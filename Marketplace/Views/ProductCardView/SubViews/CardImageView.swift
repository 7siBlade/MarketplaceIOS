//
//  CardImageView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 14.09.2026.
//

import SwiftUI

struct CardImageView: View {
    let uiImage: UIImage
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .clipped()
                .allowsHitTesting(false)
    }
}

//#Preview {
//    CardImageView()
//}
