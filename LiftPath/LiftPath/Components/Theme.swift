//
//  Theme.swift
//  LiftPath
// Components/Theme.swift

//  Created by Evan Huang on 11/8/24.

import SwiftUI

struct LiftPathTheme {
    static let primaryGreen = Color(hex: "#A8DCAB")
    static let secondaryGreen = Color(hex: "#A8DCAB")
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


extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var hexInt: UInt64 = 0
        scanner.scanHexInt64(&hexInt)
        
        let red = Double((hexInt & 0xFF0000) >> 16) / 255.0
        let green = Double((hexInt & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexInt & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

