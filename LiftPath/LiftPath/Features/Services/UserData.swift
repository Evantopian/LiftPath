//
//  UserData.swift
//  LiftPath
//
//  Created by Evan Huang on 12/2/24.
//
import Foundation
import SwiftUI

class UserData: ObservableObject {
    // Singleton instance for app-wide access
    static let shared = UserData()

    // UserDefaults keys
    private let usernameKey = "LiftPath_Username"
    private let ageKey = "LiftPath_Age"
    private let startDateKey = "LiftPath_StartDate"
    private let exerciseCacheKey = "LiftPath_ExerciseCache"
    private let favoriteExercisesKey = "LiftPath_FavoriteExercises"
    private let currentSessionKey = "LiftPath_CurrentSession"
    
    // Published properties
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: usernameKey)
        }
    }

    @Published var age: Int {
        didSet {
            UserDefaults.standard.set(age, forKey: ageKey)
        }
    }

    @Published var startDate: Date {
        didSet {
            UserDefaults.standard.set(startDate, forKey: startDateKey)
        }
    }

    // Cache for exercises by body part
    @Published var exerciseCache: [String: [Exercise]] {
        didSet {
            // Store the cache in UserDefaults as encoded data
            if let encoded = try? JSONEncoder().encode(exerciseCache) {
                UserDefaults.standard.set(encoded, forKey: exerciseCacheKey)
            }
        }
    }

    // Favorite exercises
    @Published var favoriteExercises: [Exercise] {
        didSet {
            // Store favorites in UserDefaults as encoded data
            if let encoded = try? JSONEncoder().encode(favoriteExercises) {
                UserDefaults.standard.set(encoded, forKey: favoriteExercisesKey)
            }
        }
    }
    
    // Current workout session
    @Published var currentSession: WorkoutSession? {
        didSet {
            // Store the current session in UserDefaults as encoded data
            if let session = currentSession, let encoded = try? JSONEncoder().encode(session) {
                UserDefaults.standard.set(encoded, forKey: currentSessionKey)
            }
        }
    }
    
    // Private initializer to enforce singleton pattern
     private init() {
         // Load persisted data for user data
         username = UserDefaults.standard.string(forKey: usernameKey) ?? ""
         age = UserDefaults.standard.integer(forKey: ageKey)
         
         // If no start date is saved, use current date
         startDate = UserDefaults.standard.object(forKey: startDateKey) as? Date ?? Date()

         // Load persisted exercise cache
         if let savedCacheData = UserDefaults.standard.data(forKey: exerciseCacheKey),
            let decodedCache = try? JSONDecoder().decode([String: [Exercise]].self, from: savedCacheData) {
             exerciseCache = decodedCache
         } else {
             exerciseCache = [:]  // Initialize an empty cache if none exists
         }

         // Load persisted favorite exercises
         if let savedFavoritesData = UserDefaults.standard.data(forKey: favoriteExercisesKey),
            let decodedFavorites = try? JSONDecoder().decode([Exercise].self, from: savedFavoritesData) {
             favoriteExercises = decodedFavorites
         } else {
             favoriteExercises = [] // Initialize an empty array if no favorites exist
         }

         // Load persisted current session
         if let savedSessionData = UserDefaults.standard.data(forKey: currentSessionKey),
            let decodedSession = try? JSONDecoder().decode(WorkoutSession.self, from: savedSessionData) {
             currentSession = decodedSession
         } else {
             currentSession = nil  // No session available at startup
         }
     }
    
    // Function to add exercises for a specific body part to the cache
    func addExercises(for bodyPart: String, exercises: [Exercise]) {
        exerciseCache[bodyPart] = exercises
    }

    // Function to toggle exercise as favorite
    func toggleFavorite(for exercise: Exercise) {
        if let index = favoriteExercises.firstIndex(where: { $0.id == exercise.id }) {
            favoriteExercises.remove(at: index)
        } else {
            favoriteExercises.append(exercise)
        }
    }

    // Function to get formatted start date
    func getFormattedStartDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter.string(from: startDate)
    }

    // Clear all user data including the exercise cache
    func clearAllUserData() {
        let defaults = UserDefaults.standard
        let keys = [usernameKey, ageKey, startDateKey, exerciseCacheKey, favoriteExercisesKey, currentSessionKey]
        
        keys.forEach { defaults.removeObject(forKey: $0) }
        
        // Reset properties
        username = ""
        age = 0
        startDate = Date()
        exerciseCache = [:]  // Clear the exercise cache
        favoriteExercises = []  // Clear favorite exercises
        currentSession = nil // Clear the current workout session
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
    }
}
