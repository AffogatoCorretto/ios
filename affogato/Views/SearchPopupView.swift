//
//  SearchPopupView.swift
//  affogato
//
//  Created by Kevin ahmad on 27/10/24.
//

import SwiftUI

struct SearchPopupView: View {
    @Binding var showingSearchPopup: Bool
    @State private var searchText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Drag Indicator (optional)
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height > 100 {
                                withAnimation(.spring()) {
                                    showingSearchPopup = false
                                }
                            }
                        }
                )
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for experiences...", text: $searchText)
                    .foregroundColor(.primary)
                    .accentColor(.purple)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Divider
            Divider()
                .padding(.top, 8)
            
            // Placeholder for Search Results
            Spacer()
            VStack(spacing: 16) {
                Image(systemName: "binoculars.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)
                Text("Find Your Next Adventure")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("Search for places, events, and more.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.center)
            .padding()
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height / 2)
        .background(
            Color.white
                .cornerRadius(20)
        )
        .transition(.move(edge: .bottom))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}
