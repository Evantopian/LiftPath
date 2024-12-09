//
//  Favorites.swift
//  LiftPath
//
//  Created by Evan Huang on 11/25/24.
//

import SwiftUI

struct FavoritesView: View {
    @State private var selectedTab: String = "Exercise"  // Default selected tab
    @State private var favoriteExercises: [Exercise] = [] // List of favorite exercises
    @State private var favoritedSessions: [WorkoutSession] = [] // List of favorited sessions
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background for the whole screen
                LiftPathTheme.primaryGreen
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Tab selection header with "Exercise" and "Sessions"
                    HStack {
                        Button(action: { selectedTab = "Exercise" }) {
                            Text("Exercise")
                                .font(.title2)
                                .foregroundColor(selectedTab == "Exercise" ? .black : .gray)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 50)
                            .background(Color.white)
                        
                        Button(action: { selectedTab = "Sessions" }) {
                            Text("Sessions")
                                .font(.title2)
                                .foregroundColor(selectedTab == "Sessions" ? .black : .gray)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
                    
                    // Content based on the selected tab
                    if selectedTab == "Exercise" {
                        // Exercise Tab Content
                        ScrollView {
                            VStack(spacing: 20) {
                                Text("Your Favorite Exercises")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top)

                                if favoriteExercises.isEmpty {
                                    Text("No favorites yet. Add some by tapping the heart button!")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .padding(.top, 20)
                                } else {
                                    ForEach(favoriteExercises) { exercise in
                                        ExerciseRow(exercise: exercise)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.top)
                            .frame(maxWidth: .infinity)
                        }
                        .onAppear {
                            loadFavoriteExercises() // Load the favorite exercises when the view appears
                        }
                    } else {
                        // Sessions Tab Content
                        ScrollView {
                            VStack(spacing: 20) {
                                Text("Your Favorite Sessions")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top)

                                if favoritedSessions.isEmpty {
                                    Text("No sessions yet. Add some by tapping the heart button!")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .padding(.top, 20)
                                } else {
                                    ForEach(favoritedSessions) { session in
                                        WorkoutHistoryCard(session: session)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.top)
                            .frame(maxWidth: .infinity)
                        }
                        .onAppear {
                            loadFavoritedSessions() // Load the favorited sessions when the view appears
                        }
                    }
                }
                .background(LiftPathTheme.primaryGreen)
                
                // Navigation toolbar
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("LiftPath")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
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
    
    // Load favorite exercises
    private func loadFavoriteExercises() {
        favoriteExercises = UserData.shared.favoriteExercises // Assuming UserData is set up for storing data
    }
    
    private func loadFavoritedSessions() {
        let favoritedSessionIds = UserData.shared.favoritedSessions  // Assuming you store favorited session IDs here

        // Filter sessionHistory based on whether the session ID is in favoritedSessionIds
        favoritedSessions = WorkoutSessionManager.shared.sessionHistory.filter { session in
            return favoritedSessionIds.contains(session.id)  // Check if the session ID is in the favorited session IDs list
        }
    }




}

