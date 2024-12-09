//
//  WorkoutSessionModel.swift
//  LiftPath
//
//  Created by Evan Huang on 12/7/24.
//

import Foundation

// Model for a workout session
struct WorkoutSession: Codable, Identifiable {
    var id: UUID = UUID()  // Unique identifier for each session
    var sessionName: String
    var workouts: [Exercise]  // List of exercises in the session
    var duration: TimeInterval // Total duration of the session (can be updated while active)
    var startDate: Date?  // Start date of the session (optional)
    var isCompleted: Bool // Whether the session is completed
    var isPaused: Bool  // Whether the session is paused
    var isStarted: Bool  // Whether the session has started
    var isFavorited: Bool
    
    // Initialize with default values
    init(sessionName: String, workouts: [Exercise] = [], duration: TimeInterval = 0, isCompleted: Bool = false, isPaused: Bool = false, isStarted: Bool = false, isFavorited: Bool = false) {
        self.sessionName = sessionName
        self.workouts = workouts
        self.duration = duration
        self.isCompleted = isCompleted
        self.isPaused = isPaused
        self.isStarted = isStarted
        self.isFavorited = isFavorited
    }
    
    // Method to add a workout
    mutating func addWorkout(_ workout: Exercise) {
        workouts.append(workout)
    }
    
    // Method to remove a workout
    mutating func removeWorkout(_ workout: Exercise) {
        workouts.removeAll { $0.name == workout.name }
    }
    
    // Method to start the session
    mutating func startSession() {
        startDate = Date()
        isStarted = true
        isCompleted = false // Reset completion status when a new session starts
        isPaused = false    // Ensure it's not paused at the start
    }
    
    // Method to stop the session
    mutating func stopSession() {
        duration = Date().timeIntervalSince(startDate ?? Date())
        isCompleted = true
        isPaused = false    // Ensure session is not paused when completed
    }
    
    // Method to pause the session
    mutating func pauseSession() {
        isPaused = true
    }
    
    // Method to resume the session
    mutating func resumeSession() {
        isPaused = false
        startDate = Date()  // Optionally update the session's startTime to account for the pause duration
    }
    
    // Method to reset the session (for a new session)
    mutating func resetSession() {
        workouts.removeAll()
        startDate = nil
        duration = 0
        isCompleted = false
        isPaused = false
        isStarted = false
    }
    
    mutating func toggleFavorite() {
        isFavorited.toggle()
    }
}
