//
//  ProfileView.swift
//  affogato
//
//  Created by Kevin ahmad on 06/10/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var memojiImage: UIImage = UIImage(named: "memoji")!
    @State private var showingImagePicker = false
    @State private var username: String = ""
    @State private var bio: String = ""
    @AppStorage("memojiImageData") var memojiImageData: Data = Data()
    @AppStorage("username") var storedUsername: String = ""
    @AppStorage("bio") var storedBio: String = ""
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            // Profile Picture
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(radius: 10)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )

                Image(uiImage: memojiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
            }
            .onTapGesture {
                showingImagePicker = true
            }
            .padding(.top, 40)
            Text("Edit")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            // Username Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("Enter your Name", text: $username)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
            }
            .padding(.horizontal)

//            // Bio Field
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Bio")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//                TextEditor(text: $bio)
//                    .frame(height: 100)
//                    .padding(4)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(.systemGray6))
//                    )
//            }
//            .padding(.horizontal)
            // Save Button
            Button(action: {
                saveProfile()
            }) {
                Text("Save Changes")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(25)
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()
        }
        .navigationBarTitle("Profile", displayMode: .inline)
        .background(
            colorScheme == .light ? Color.white : Color.black
        )
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $memojiImage)
        }
        .onAppear {
            loadProfile()
        }
    }

    // Save profile data
    func saveProfile() {
        // Save memoji image
        if let imageData = memojiImage.jpegData(compressionQuality: 0.8) {
            memojiImageData = imageData
        }
        // Save username and bio
        storedUsername = username
        storedBio = bio
    }

    // Load profile data
    func loadProfile() {
        // Load memoji image
        if !memojiImageData.isEmpty, let image = UIImage(data: memojiImageData) {
            memojiImage = image
        }
        // Load username and bio
        username = storedUsername
        bio = storedBio
    }
}
