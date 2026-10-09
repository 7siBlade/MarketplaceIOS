//
//  AddPhotoViewModel.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 07.10.2026.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import Combine

@MainActor
final class AddProductViewModel: ObservableObject {
    @Published var titlePhoto = ""
    @Published var description = ""
    @Published var selectedImage: UIImage? = nil
    @Published var pickerItem: PhotosPickerItem? = nil {
        didSet { handlePickerItemChange() }
    }
    
    @Published var isUploading = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var shouldDismiss = false
    
    private let db = Firestore.firestore()
    private let imageConverter = ImageBase64()
    var authViewModel = AuthViewModel()
    
    private func handlePickerItemChange() {
        guard let pickerItem else { return }
        Task {
            if let data = try? await pickerItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                self.selectedImage = image
            }
        }
    }
    
    func saveProduct() async {
        var base64String = ""
        guard let image = selectedImage else { return }
        isUploading = true
        
        do {
            base64String = try imageConverter.encodeImageToBase64(image)
        } catch {
            alertMessage = "Error: \(error.localizedDescription)"
            showAlert = true
            isUploading = false
            return
        }
        
        let productId = UUID().uuidString
        
        do {
            try await db.collection("shop").document(productId).setData([
                "name": titlePhoto,
                "description": description,
                "image": base64String,
                "author": authViewModel.user?.name ?? "Unknown user",
                "isFavorite": false
            ])
            
            alertMessage = "Success!"
            showAlert = true
            shouldDismiss = true
        } catch {
            alertMessage = "Error: \(error.localizedDescription)"
            showAlert = true
        }
        
        isUploading = false
    }
}
