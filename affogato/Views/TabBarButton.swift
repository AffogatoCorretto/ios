//
//  TabBarButton.swift
//  affogato
//
//  Created by Kevin ahmad on 27/10/24.
//

import SwiftUI

struct TabBarButton: View {
    let systemName: String
    let isSelected: Bool

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 24))
            .foregroundColor(isSelected ? .primary : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
    }
}
