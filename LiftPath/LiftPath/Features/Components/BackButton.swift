//
//  BackButton.swift
//  LiftPath
//
//  Created by Evan Huang on 12/9/24.
//

import SwiftUI

struct BackButtonView: View {
    var color: Color
    @Environment(\.presentationMode) var presentationMode // To manage the navigation stack
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss() // Go back to the previous view
            }) {
                Image(systemName: "chevron.left") // Chevron symbol
                    .font(.title)
                    .foregroundColor(color)
                    .padding(.leading, 10) // Moved closer to the left
            }
            Spacer()
        }
    }
}
