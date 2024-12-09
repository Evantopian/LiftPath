//
//  Favorites.swift
//  LiftPath
//
//  Created by Evan Huang on 11/25/24.
//

import SwiftUI

struct FavoritesView: View {
    @State private var selectedTab: FavoritesTab = .exercises
    @State private var favoriteExercises: [Exercise] = []
    @State private var favoritedSessions: [WorkoutSession] = []
    
    enum FavoritesTab {
        case exercises
        case sessions
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Modern Segmented Control
                CustomSegmentedControl(selectedTab: $selectedTab)
                
                // Content Area
                ZStack {
                    LiftPathTheme.primaryGreen.opacity(0.1)
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            headerTitle
                            
                            contentView
                        }
                        .padding()
                    }
                }
            }
            .liftPathToolbar(textColor: LiftPathTheme.primaryGreen, iconColor: LiftPathTheme.primaryGreen)
        }
        .accentColor(LiftPathTheme.primaryGreen)
    }
    
    private var headerTitle: some View {
        Text(selectedTab == .exercises ? "Favorite Exercises" : "Favorite Workout Sessions")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(LiftPathTheme.primaryGreen)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contentView: some View {
        Group {
            switch selectedTab {
            case .exercises:
                exercisesContent
            case .sessions:
                sessionsContent
            }
        }
    }
    
    private var exercisesContent: some View {
        Group {
            if favoriteExercises.isEmpty {
                emptyStateView(message: "No favorite exercises yet")
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(favoriteExercises) { exercise in
                        ExerciseRow(exercise: exercise)
                            .transition(.slide)
                    }
                }
            }
        }
        .onAppear(perform: loadFavoriteExercises)
    }
    
    private var sessionsContent: some View {
        Group {
            if favoritedSessions.isEmpty {
                emptyStateView(message: "No favorite workout sessions")
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(favoritedSessions) { session in
                        WorkoutHistoryCard(session: session)
                            .transition(.slide)
                    }
                }
            }
        }
        .onAppear(perform: loadFavoritedSessions)
    }
    
    private func emptyStateView(message: String) -> some View {
        VStack(spacing: 15) {
            Image(systemName: "heart.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(LiftPathTheme.primaryGreen.opacity(0.5))
            
            Text(message)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.7))
        .cornerRadius(15)
    }
    
    private func loadFavoriteExercises() {
        favoriteExercises = UserData.shared.favoriteExercises
    }
    
    private func loadFavoritedSessions() {
        let favoritedSessionIds = UserData.shared.favoritedSessions
        favoritedSessions = WorkoutSessionManager.shared.sessionHistory.filter {
            favoritedSessionIds.contains($0.id)
        }
    }
}

// Custom Segmented Control
struct CustomSegmentedControl: View {
    @Binding var selectedTab: FavoritesView.FavoritesTab
    
    var body: some View {
        HStack(spacing: 0) {
            tabButton(for: .exercises, title: "Exercises")
            tabButton(for: .sessions, title: "Sessions")
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding()
    }
    
    private func tabButton(for tab: FavoritesView.FavoritesTab, title: String) -> some View {
        Button(action: { selectedTab = tab }) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(selectedTab == tab ? .white : LiftPathTheme.primaryGreen)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(selectedTab == tab ? LiftPathTheme.primaryGreen : Color.clear)
                .cornerRadius(10)
        }
    }

}
