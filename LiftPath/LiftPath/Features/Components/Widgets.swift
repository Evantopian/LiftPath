//
//  Widgets.swift
//  LiftPath
//
//  Created by Evan Huang on 11/25/24.
//
import SwiftUI

class NavigationState: ObservableObject {
    @Published var selectedTab: String = "dumbbell.fill"
}

struct NavigationContainerView<Content: View>: View {
    let content: Content
    @StateObject private var navigationState = NavigationState()
    
    private let tabs = [
        (icon: "heart.circle.fill", title: "Health"),
        (icon: "dumbbell.fill", title: "Home"),
        (icon: "chart.bar.fill", title: "Stats")
    ]
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                content
                    .padding(.bottom, 10)
                
                // tab bar
                HStack {
                    ForEach(tabs, id: \.icon) { tab in
                        Button(action: {
                            navigationState.selectedTab = tab.icon
                        }) {
                            Image(systemName: tab.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(navigationState.selectedTab == tab.icon ? LiftPathTheme.primaryGreen : .black)
                                .shadow(color: navigationState.selectedTab == tab.icon ? .gray.opacity(0.5) : .clear, radius: 5, x: 0, y: 2)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 10)
                .background(Color.white)
            }



            Group {
                if navigationState.selectedTab == "heart.circle.fill" {
                    NavigationLink(destination: FavoritesView()) {
                        FavoritesView()
                    }
                } else if navigationState.selectedTab == "dumbbell.fill" {
                    NavigationLink(destination: HomeView()) {
                        EmptyView()
                    }
                } else if navigationState.selectedTab == "chart.bar.fill" {
                    NavigationLink(destination: StatsView()) {
                        EmptyView()
                    }
                }
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
}
