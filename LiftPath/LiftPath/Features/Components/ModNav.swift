//
//  ModNav.swift
//  LiftPath
//
//  Created by Evan Huang on 12/2/24.
//

import SwiftUI
struct BottomNavbar: View {
    @Binding var selectedTab: String

    private let tabs = [
        (icon: "heart.circle.fill", title: "Favorites", tag: "Favorites"),
        (icon: "dumbbell.fill", title: "Home", tag: "Home"),
        (icon: "chart.bar.fill", title: "Stats", tag: "Stats")
    ]

    var body: some View {
        HStack {
            ForEach(tabs, id: \.icon) { tab in
                Button(action: {
                    selectedTab = tab.tag // Switch the selected tab
                }) {
                    VStack {
                        Image(systemName: tab.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(selectedTab == tab.tag ? LiftPathTheme.primaryGreen : .black)
                        Text(tab.title)
                            .font(.caption)
                            .foregroundColor(selectedTab == tab.tag ? LiftPathTheme.primaryGreen : .black)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .shadow(radius: 5)
    }
}
