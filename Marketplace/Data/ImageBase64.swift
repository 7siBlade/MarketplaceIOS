//
//  ImageBase64.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 14.09.2026.
//

import Foundation
import UIKit

struct ImageBase64 {
    func imageFromBase64(_ base64String: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: data)
    }
}
