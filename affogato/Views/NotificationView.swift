//
//  NotificationView.swift
//  affogato
//
//  Created by Kevin ahmad on 23/11/24.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Spacer()
                Text("Notifications")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
            
            Spacer()
            
            // Content
            VStack(spacing: 16) {
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)
                Text("Thanks for trying our app! 🎉")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Text("We'd love to hear your feedback.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    // Handle feedback action
                }) {
                    Text("Give Feedback")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    // Handle share action
                    shareApp()
                }) {
                    Text("Share with Friends")
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.purple, lineWidth: 2)
                        )
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func shareApp() {
        // Implement share functionality
        let items = ["Check out this awesome app!"]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // For SwiftUI
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
