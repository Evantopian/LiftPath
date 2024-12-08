//
//  Favorites.swift
//  LiftPath
//
//  Created by Evan Huang on 11/25/24.
//

import SwiftUI

struct FavoritesView: View {
    @State private var selectedTab: String = "heart.circle.fill"
    @State private var favorites: [Exercise] = [] // This will store the list of favorite exercises
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background for the whole screen
                LiftPathTheme.primaryGreen
                    .edgesIgnoringSafeArea(.all)
                
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Your Favorite Exercises")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top)

                        if favorites.isEmpty {
                            Text("No favorites yet. Add some by tapping the heart button!")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                        } else {
                            ForEach(favorites) { exercise in
                                ExerciseRow(exercise: exercise)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top) // Optional: only adds top padding
                    .frame(maxWidth: .infinity) // Ensures content fills the width of the screen
                }
                .onAppear {
                    loadFavorites() // Load the favorites when the view appears
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
    
    func loadFavorites() {
        // Load the list of favorite exercises from UserData
        self.favorites = UserData.shared.favoriteExercises // Access the favorite exercises from UserData
    }
}
