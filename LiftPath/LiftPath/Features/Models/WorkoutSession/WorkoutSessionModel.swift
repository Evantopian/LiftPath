//
//  WorkoutSessionModel.swift
//  LiftPath
//
//  Created by Evan Huang on 12/7/24.
//

import Foundation

// Model for a workout session
struct WorkoutSession: Codable {
    var sessionName: String
    var workouts: [Exercise]  // List of exercises in the session
    var duration: TimeInterval // Total duration of the session (can be updated while active)
    var startTime: Date?  // Start time of the session (optional)
    var endTime: Date?  // End time of the session (optional)
    
    // Initialize with default values
    init(sessionName: String, workouts: [Exercise] = [], duration: TimeInterval = 0) {
        self.sessionName = sessionName
        self.workouts = workouts
        self.duration = duration
    }
    
    // Method to add a workout
    mutating func addWorkout(_ workout: Exercise) {
        workouts.append(workout)
    }
    
    // Method to remove a workout
    mutating func removeWorkout(named name: String) {
        workouts.removeAll { $0.name == name }
    }
    
    // Method to start the session
    mutating func startSession() {
        startTime = Date()
    }
    
    // Method to stop the session
    mutating func stopSession() {
        endTime = Date()
        duration = endTime?.timeIntervalSince(startTime ?? Date()) ?? 0
    }
    
    // Method to reset the session (for a new session)
    mutating func resetSession() {
        workouts.removeAll()
        startTime = nil
        endTime = nil
        duration = 0
    }
}
