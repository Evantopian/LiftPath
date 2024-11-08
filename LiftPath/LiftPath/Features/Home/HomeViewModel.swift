//
//  Features/Home/HomeViewModel.swift
//  LiftPath
//
//  Created by Evan Huang on 11/8/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var featuredWorkouts: [WorkoutCategory] = []
    @Published var otherWorkouts: [WorkoutCategory] = []
    @Published var username: String = "Username"
    @Published var completedWorkouts: Int = 30
    @Published var streakDays: Int = 12
    
    init() {
        loadWorkoutCategories()
    }
    
    private func loadWorkoutCategories() {
        featuredWorkouts = [
            WorkoutCategory(name: "Dumbbell Workouts",
                          image: "dumbbell.fill",
                          description: "Build strength with dumbbells"),
            WorkoutCategory(name: "Cardio Workouts",
                          image: "figure.run",
                          description: "Improve endurance")
        ]
        
        otherWorkouts = [
            WorkoutCategory(name: "Equipment Workouts",
                          image: "sportscourt.fill",
                          description: "Gym equipment exercises"),
            WorkoutCategory(name: "Home Workouts",
                          image: "house.fill",
                          description: "No equipment needed")
        ]
    }
}
