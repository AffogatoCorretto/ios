//
//  ActivityDetailView.swift
//  affogato
//
//  Created by Kevin ahmad on 27/10/24.
//

import SwiftUI

struct ActivityDetailView: View {
    let special: Special
    @State private var isFullScreenPresented = false

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Full-width image at the top
                if let firstImageURL = special.images.first, let url = URL(string: firstImageURL) {
                    RemoteImageView(url: url)
                        .frame(height: 400)
                        .aspectRatio(contentMode: .fill)
                        .overlay(
                            VStack {
                                Spacer() // Pushes content to bottom
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(special.itemName)
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Text("\(special.distance, specifier: "%.1f") Miles away from you")
                                            .font(.subheadline)
                                        HStack {
                                            ForEach(0..<Int(special.rating.rounded())) { _ in
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                    }
                                    Spacer()
                                    Button(action: {
                                        isFullScreenPresented = true
                                    }) {
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.black.opacity(0.5))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
                            }
                            .foregroundColor(.white)
                        )
                        .clipped()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(special.itemName)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Address: \(special.itemName)") // Assuming `itemName` as a placeholder for the address
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    HStack {
                        ForEach(0..<Int(special.rating.rounded())) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        Text("(\(special.ratingCount) reviews)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Divider()

                    Text("Specialties")
                        .font(.headline)

                    // List specialties
                    if !special.specialties.isEmpty {
                        ForEach(special.specialties, id: \.self) { specialty in
                            Text(specialty)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("No specialties available.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    Text("Gallery")
                        .font(.headline)

                    // Display other images in grid format as a gallery
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(special.images.dropFirst(), id: \.self) { imageUrl in
                            if let url = URL(string: imageUrl) {
                                RemoteImageView(url: url)
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationTitle("Details")
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            FullScreenImageView(special: special, isPresented: $isFullScreenPresented)
        }
    }
}
