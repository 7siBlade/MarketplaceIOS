//
//  Product.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 08.09.2026.
//

import Foundation
import FirebaseFirestore

struct Product: Identifiable, Codable{
    @DocumentID var id: String?
    var name: String
    var description: String
    var image: String
    var price: Int
    var isFavorite: Bool
    var quantityInCart: Int?
}
