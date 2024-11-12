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
    @Published var username: String = "TempName"
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
                          description: "Improve endurance"),
            WorkoutCategory(name: "HIIT Training",
                          image: "bolt.fill",
                          description: "High intensity intervals"),
            WorkoutCategory(name: "Yoga Flow",
                          image: "figure.mind.and.body",
                          description: "Flexibility and balance"),
            WorkoutCategory(name: "Core Strength",
                          image: "figure.core.training",
                          description: "Build core stability")
        ]
        
        otherWorkouts = [
            WorkoutCategory(name: "Equipment Workouts",
                          image: "sportscourt.fill",
                          description: "Gym equipment exercises"),
            WorkoutCategory(name: "Home Workouts",
                          image: "house.fill",
                          description: "No equipment needed"),
            WorkoutCategory(name: "Strength Training",
                          image: "figure.strengthtraining.traditional",
                          description: "Build muscle and power"),
            WorkoutCategory(name: "Recovery",
                          image: "figure.walk",
                          description: "Active recovery exercises"),
            WorkoutCategory(name: "Flexibility",
                          image: "figure.flexibility",
                          description: "Stretching routines")
        ]
    }
}
