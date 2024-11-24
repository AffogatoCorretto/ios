//
//  affogatoApp.swift
//  affogato
//
//  Created by Kevin ahmad on 06/10/24.
//

import SwiftUI

@main
struct affogatoApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView() // Start with the splash screen
                .preferredColorScheme(.light) // Enforce light mode
        }
    }
}
