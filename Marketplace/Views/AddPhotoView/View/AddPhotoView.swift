//
//  AddPhotoView.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 07.10.2026.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: View {
    @StateObject private var viewModel = AddProductViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var shouldRefresh: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.secondary.opacity(0.3)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        PhotosPicker(selection: $viewModel.pickerItem, matching: .images) {
                            ZStack {
                                if let selectedImage = viewModel.selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                        .clipped()
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.largeTitle)
                                        Text("Select Photo")
                                            .font(.headline)
                                    }
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .bold()
                            
                            TextField("Photo title", text: $viewModel.titlePhoto)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .bold()
                            
                            TextField("Description", text: $viewModel.description)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                        }
                        
                        if viewModel.isUploading {
                            ProgressView()
                                .padding()
                        } else {
                            Button {
                                Task {
                                    await viewModel.saveProduct()
                                    shouldRefresh = true
                                }
                            } label: {
                                Text("Add Product")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(viewModel.titlePhoto.isEmpty || viewModel.selectedImage == nil ? Color.gray : Color.blue)
                                    .cornerRadius(12)
                            }
                            .disabled(viewModel.titlePhoto.isEmpty || viewModel.selectedImage == nil)
                        }
                    }
                    .padding(16)
                }
                .navigationTitle("Add photo")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Status", isPresented: $viewModel.showAlert) {
                    Button("OK", role: .cancel) {
                        if viewModel.shouldDismiss {
                            shouldRefresh = true
                            dismiss()
                        }
                    }
                } message: {
                    Text(viewModel.alertMessage)
                }
            }
        }
    }
}

//#Preview {
//    AddPhotoView()
//}
