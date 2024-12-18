//
//  ActivityDetailView.swift
//  affogato
//
//  Created by Kevin Ahmad on 27/10/24.
//

import SwiftUI

struct ActivityDetailView: View {
    let special: Special
    @State private var isFullScreenPresented = false
    @Environment(\.presentationMode) var presentationMode

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Full-width image at the top
                if let firstImageURL = special.images.first, let url = URL(string: firstImageURL) {
                    ZStack(alignment: .topLeading) {
                        RemoteImageView(url: url)
                            .frame(height: 400)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                            .contentShape(Rectangle()) // Makes the entire image tappable
                            .onTapGesture {
                                isFullScreenPresented = true
                            }

                        // Custom back button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44)
                        .padding(.leading, 16)
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(special.itemName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    HStack {
                                        ForEach(0..<Int(special.rating.rounded())) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                        ForEach(0..<(5 - Int(special.rating.rounded()))) { _ in
                                            Image(systemName: "star")
                                                .foregroundColor(.gray)
                                        }
                                        Text("(\(special.ratingCount))")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .edgesIgnoringSafeArea(.bottom)
                            )
                        }
                    )
                }

                VStack(alignment: .leading, spacing: 16) {
                    // Parse sub_category if available
                    if let subCategoryString = special.subCategory,
                       let data = subCategoryString.data(using: .utf8),
                       let subCategories = try? JSONDecoder().decode([String].self, from: data), !subCategories.isEmpty {
                        Text("Sub Categories")
                            .font(.headline)
                            .fontWeight(.bold)
                        ForEach(subCategories, id: \.self) { subCat in
                            Text("• \(subCat)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }

                    // Display description if available
                    if !special.description.isEmpty {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(special.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    if !special.category.isEmpty {
                        Text("Category: \(special.category.capitalized.replacingOccurrences(of: "_&_", with: " & "))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    if !special.priceRange.isEmpty {
                        Text("Price Range: \(special.priceRange)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Specialties Section
                    if !special.specialties.isEmpty {
                        Text("Specialties")
                            .font(.headline)
                            .fontWeight(.bold)
                        ForEach(special.specialties, id: \.self) { specialty in
                            Text("• \(specialty)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }

                    // Gallery Section
                    if special.images.count > 1 {
                        Text("Gallery")
                            .font(.headline)
                            .fontWeight(.bold)
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(special.images.dropFirst(), id: \.self) { imageUrl in
                                if let url = URL(string: imageUrl) {
                                    RemoteImageView(url: url)
                                        .frame(height: 100)
                                        .cornerRadius(10)
                                        .clipped()
                                        .onTapGesture {
                                            // Show fullscreen for tapped image as well
                                            isFullScreenPresented = true
                                        }
                                }
                            }
                        }
                    }
                }
                .padding()

            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            FullScreenImageView(special: special, isPresented: $isFullScreenPresented)
        }
    }
}

struct FullScreenDetailImageView: View {
    let special: Special
    @Binding var isPresented: Bool
    @State private var showDownloadConfirmation = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView {
                ForEach(special.images, id: \.self) { imageUrl in
                    if let url = URL(string: imageUrl) {
                        RemoteImageView(url: url)
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                isPresented = false
                            }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .background(Color.black.edgesIgnoringSafeArea(.all))
            
            // Small subtle download button
            Button(action: {
                // Implement download logic here
                showDownloadConfirmation = true
            }) {
                Image(systemName: "arrow.down.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .padding([.top, .trailing], 20)
            }
        }
        .alert(isPresented: $showDownloadConfirmation) {
            Alert(title: Text("Downloaded"), message: Text("Image saved."), dismissButton: .default(Text("OK")))
        }
    }
}
