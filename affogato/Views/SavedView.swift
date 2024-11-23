//
//  SavedView.swift
//  affogato
//
//  Created by Kevin ahmad on 23/11/24.
//

import SwiftUI

struct SavedView: View {
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(.purple)
                .padding(.bottom, 16)
            Text("Your saved items will appear here.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
