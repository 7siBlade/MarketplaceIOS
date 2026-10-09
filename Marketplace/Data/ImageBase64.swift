//
//  ImageBase64.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 14.09.2026.
//

import Foundation
import UIKit

enum ImageCompressionError: LocalizedError {
    case jpegConversionFailed
    case compressionFailed
    
var errorDescription: String? {
        switch self {
        case .jpegConversionFailed:
            return "Failed to convert the image to JPEG."
        case .compressionFailed:
            return "Failed to compress the image to 1 MB."
        }
    }
}

struct ImageBase64 {
    func decodeBase64ToImage(_ base64String: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: data)
    }
    
    //    func encodeImageToBase64(_ image: UIImage) -> String? {
    //        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return nil }
    //        return imageData.base64EncodedString()
    //    }
    
    func encodeImageToBase64(_ image: UIImage) throws -> String {
        let maxSize = 800 * 1024
        var maxDimension: CGFloat = 1600
            
        while maxDimension >= 400 {
            let resizedImage = resizeImage(
                image: image,
                maxDimension: maxDimension
            )
                
            var quality: CGFloat = 0.8
                
            while quality >= 0.1 {
                guard let data = resizedImage.jpegData(
                    compressionQuality: quality
                ) else {
                    throw ImageCompressionError.jpegConversionFailed
                }
                    
                if data.count <= maxSize {
                    return data.base64EncodedString()
                }
                quality -= 0.1
            }
            maxDimension *= 0.75
        }
        throw ImageCompressionError.compressionFailed
    }
        
    private func resizeImage(
        image: UIImage,
        maxDimension: CGFloat
    ) -> UIImage {
        let originalSize = image.size
        let longestSide = max(originalSize.width, originalSize.height)
            
        guard longestSide > maxDimension else {
            return image
        }
            
        let scale = maxDimension / longestSide
            
        let newSize = CGSize(
            width: originalSize.width * scale,
            height: originalSize.height * scale
        )
            
        let renderer = UIGraphicsImageRenderer(size: newSize)
            
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
