//
//  ContentView.swift
//  LiftPath
//
//  Created by Evan Huang on 11/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "Home"

    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case "Favorites":
                FavoritesView()
            case "Home":
                HomeView()
            case "Stats":
                StatsView()
            default:
                Text("Unknown Tab")
            }

            BottomNavbar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
