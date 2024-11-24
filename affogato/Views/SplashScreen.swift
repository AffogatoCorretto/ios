//
//  SplashScreen.swift
//  affogato
//
//  Created by Kevin ahmad on 23/11/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView() // Transition to your main content
        } else {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Logo and Text
                VStack {
                    Image("robot-head")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    Text("Curated Adventures, Just for You ✨")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .multilineTextAlignment(.center) // Center align text
                    
                    Text("- Affogato")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 10)
                        .multilineTextAlignment(.center) // Center align text
                }
                .opacity(0.8)
                .scaleEffect(0.8)
                .animation(.easeIn(duration: 1.5), value: isActive)
            }
            .onAppear {
                // Simulate loading time
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
