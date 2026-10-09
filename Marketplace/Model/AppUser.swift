//
//  AppUser.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 05.10.2026.
//

import Foundation
import FirebaseFirestore

struct AppUser: Codable {
    let uid: String
    let name: String
    let email: String
    let createdAt: Date
}
