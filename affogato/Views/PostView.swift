//
//  PostView.swift
//  affogato
//
//  Created by Kevin ahmad on 06/10/24.
//

import SwiftUI

struct PostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Activity Title", text: $viewModel.title)
                // Add more fields for post creation
            }
            .navigationTitle("New Activity")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Post") {
                    viewModel.createPost()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(!viewModel.isValid)
            )
        }
    }
}
