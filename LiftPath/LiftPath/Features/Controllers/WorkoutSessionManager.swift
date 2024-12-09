//
//  WorkoutSessionManager.swift
//  LiftPath
//
//  Created by Evan Huang on 12/8/24.
//

import Foundation
import SwiftUI

class WorkoutSessionManager: ObservableObject {
    @Published var currentSession: WorkoutSession?
    @Published var sessionHistory: [WorkoutSession] = []
    
    static let shared = WorkoutSessionManager()
    
    private let historyKey = "workoutSessionsHistory"
    private let currentSessionKey = "currentWorkoutSession"
    
    private var timer: Timer?
    
    private init() {
        loadHistoryFromUserDefaults()
        loadCurrentSession()
    }
    
    // Create a new session without starting the timer
    func createSession(sessionName: String? = nil) {
        let name = sessionName ?? "Workout Session \(sessionHistory.count + 1)"
        currentSession = WorkoutSession(sessionName: name, workouts: [])
        saveCurrentSession()
    }
    
    // Start the session and begin the timer
    func startSession() {
        guard currentSession != nil else { return }
        startTimer()
        saveCurrentSession()
        currentSession?.isStarted = true
    }
    
    // Start the timer and continue it even when the view disappears
    private func startTimer() {
        guard currentSession != nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentSession?.duration += 1
            self.saveCurrentSession()
        }
    }
    
    // Pause the timer
    func pauseCurrentSession() {
        guard currentSession != nil else { return }
        timer?.invalidate()
        currentSession?.isPaused = true
        
    }
    
    // Resume the timer
    func resumeCurrentSession() {
        guard currentSession != nil else { return }
        startTimer()
        currentSession?.isPaused = false
    }
    
    // Complete the session
    func completeCurrentSession() {
        timer?.invalidate()
        if var session = currentSession {
            session.isCompleted = true
            sessionHistory.append(session)
            saveHistoryToUserDefaults()
        }
        currentSession = nil
        UserDefaults.standard.removeObject(forKey: currentSessionKey) 
        saveCurrentSession()
    }

    
    // Cancel the session
    func cancelCurrentSession() {
        timer?.invalidate()
        currentSession = nil
    }
    
    // Persistence methods
    func saveHistoryToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(sessionHistory)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("Failed to save session history: \(error)")
        }
    }
    
    private func loadHistoryFromUserDefaults() {
        //clearAllSessionData()
        guard let data = UserDefaults.standard.data(forKey: historyKey) else { return }
        do {
            sessionHistory = try JSONDecoder().decode([WorkoutSession].self, from: data)
        } catch {
            print("Failed to load session history: \(error)")
        }
    }
    
    func saveCurrentSession() {
        guard let session = currentSession else { return }
        do {
            let data = try JSONEncoder().encode(session)
            UserDefaults.standard.set(data, forKey: currentSessionKey)
        } catch {
            print("Failed to save current session: \(error)")
        }
    }
    
    func loadCurrentSession() {
        // Check if the current session data exists in UserDefaults
        guard let data = UserDefaults.standard.data(forKey: currentSessionKey) else {
            print("No session history found.")
            return  // No session history, return early
        }
        
        do {
            currentSession = try JSONDecoder().decode(WorkoutSession.self, from: data)
            print("Session loaded successfully.")
        } catch {
            print("Failed to load current session: \(error)")
        }
    }
    
    func changeSessionName(newName: String) {
        guard var session = currentSession else { return }
        session.sessionName = newName
        currentSession = session
        saveCurrentSession()
    }
    
    func addExerciseToCurrentSession(_ exercise: Exercise) {
        // Only add the exercise if there is an existing session
        if var currentSession = currentSession {
            if !currentSession.workouts.contains(where: { $0.id == exercise.id }) {
                currentSession.addWorkout(exercise)
                self.currentSession = currentSession  // Reassign the modified session
                saveCurrentSession()
            }
        } else {
            // No active session, create a new one with a dynamic name based on history count
            let sessionCount = sessionHistory.count + 1
            let sessionName = "Workout Session \(sessionCount)"
            
            var newSession = WorkoutSession(sessionName: sessionName)
            newSession.addWorkout(exercise)
            currentSession = newSession  // Assign the new session without starting it
            saveCurrentSession()
            
            print("No active session. A new session has been created with name: \(sessionName) and exercise added.")
        }
    }


    
    func removeExerciseFromCurrentSession(_ exercise: Exercise) {
        guard var session = currentSession else { return }
        session.removeWorkout(exercise)
        currentSession = session
        saveCurrentSession()
    }
    
    func clearAllSessionData() {
        currentSession = nil
        sessionHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: currentSessionKey)
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
    
    func formattedDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
