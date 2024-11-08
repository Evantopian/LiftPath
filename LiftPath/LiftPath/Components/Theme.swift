//
//  Theme.swift
//  LiftPath
// Components/Theme.swift

//  Created by Evan Huang on 11/8/24.

import SwiftUI

struct LiftPathTheme {
    static let primaryGreen = Color(red: 183/255, green: 223/255, blue: 177/255)
    static let secondaryGreen = Color(red: 163/255, green: 203/255, blue: 157/255)
    static let textColor = Color.black
    static let backgroundColor = Color.white
    
    struct ButtonStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(LiftPathTheme.primaryGreen)
                .foregroundColor(LiftPathTheme.textColor)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
    
    struct CardStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 2)
        }
    }
}

extension View {
    func liftPathButton() -> some View {
        modifier(LiftPathTheme.ButtonStyle())
    }
    
    func liftPathCard() -> some View {
        modifier(LiftPathTheme.CardStyle())
    }
}

// Models/WorkoutCategory.swift
struct WorkoutCategory: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let description: String
}
