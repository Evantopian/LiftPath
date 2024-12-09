//
//  LiftPathToolBar.swift
//  LiftPath
//
//  Created by Evan Huang on 12/9/24.
//

import SwiftUI

struct LiftPathToolbar: ViewModifier {
    var textColor: Color
    var iconColor: Color
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("LiftPath")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(iconColor)
                        }
                    }
                }
            }
    }
}

extension View {
    func liftPathToolbar(textColor: Color = .white, iconColor: Color = .white) -> some View {
        self.modifier(LiftPathToolbar(textColor: textColor, iconColor: iconColor))
    }
}
