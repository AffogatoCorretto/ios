//
//  ActivityView.swift
//  affogato
//
//  Created by Kevin ahmad on 06/10/24.
//

import SwiftUI

struct ActivityView: View {
    let activity: Activity
    
    var body: some View {
        VStack {
            Spacer() // Pushes everything to the center vertically
            HStack {
                Spacer() // Pushes everything to the center horizontally
                VStack(alignment: .center) {
                    Image(systemName: "figure.run")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                    
                    Text(activity.title)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text("Swipe up/down to change activities")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                Spacer() // Pushes everything to the center horizontally
            }
            Spacer() // Pushes everything to the center vertically
        }
        .padding()
    }
}
