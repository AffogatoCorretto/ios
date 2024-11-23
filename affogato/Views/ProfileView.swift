//
//  ProfileView.swift
//  affogato
//
//  Created by Kevin ahmad on 06/10/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text(viewModel.username)
                    .font(.title)
                Text(viewModel.bio)
                    .font(.subheadline)
                    .padding()
                
                // Add more profile content here
            }
            .navigationTitle("Profile")
        }
    }
}
