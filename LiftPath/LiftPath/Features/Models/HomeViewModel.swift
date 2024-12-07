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
    @Published var completedWorkouts: Int = 30
    @Published var streakDays: Int = 12
    
    init() {
        loadWorkoutCategories()
    }
    
    private func loadWorkoutCategories() {
        featuredWorkouts = [
            WorkoutCategory(name: "Waist", image: "figure.mind.and.body", description: "Focus on waist and core workouts"),
            WorkoutCategory(name: "Shoulders", image: "figure.hiking", description: "Develop shoulder stability"),
            WorkoutCategory(name: "Back", image: "back.circle.fill", description: "Strengthen your back muscles"),
            WorkoutCategory(name: "Cardio", image: "figure.run", description: "Boost your cardiovascular health"),
            WorkoutCategory(name: "Chest", image: "figure.pacman", description: "Build chest strength"),
            WorkoutCategory(name: "Lower Arms", image: "figure.hand.point.up", description: "Target lower arms"),
            WorkoutCategory(name: "Lower Legs", image: "figure.walk", description: "Strengthen calves and shins"),
            WorkoutCategory(name: "Neck", image: "figure.head", description: "Neck strengthening exercises"),
            WorkoutCategory(name: "Upper Arms", image: "figure.arm.front", description: "Build upper arm strength"),
            WorkoutCategory(name: "Upper Legs", image: "figure.mountain", description: "Strengthen thighs and quads")
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
