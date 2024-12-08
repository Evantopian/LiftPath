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

    private init() {
        loadHistoryFromUserDefaults()
        loadCurrentSession()
    }

    func addExerciseToCurrentSession(_ exercise: Exercise) {
        if currentSession == nil {
            startNewSession(sessionName: "Workout Session")
        }

        if !currentSession!.workouts.contains(where: { $0.id == exercise.id }) {
            currentSession!.addWorkout(exercise)
            saveCurrentSession()
        }
    }

    func startNewSession(sessionName: String? = nil) {
        let name = sessionName ?? "Workout Session \(sessionHistory.count + 1)"
        currentSession = WorkoutSession(sessionName: name, workouts: [])
        saveCurrentSession()
    }

    func completeCurrentSession() {
        guard var session = currentSession else { return }
        
        session.stopSession()  // This sets end time and marks as completed
        sessionHistory.append(session)
        
        saveHistoryToUserDefaults()
        currentSession = nil
        UserDefaults.standard.removeObject(forKey: currentSessionKey)
    }

    func cancelCurrentSession() {
        currentSession = nil
        UserDefaults.standard.removeObject(forKey: currentSessionKey)
    }

    // Persistence methods
    public func saveHistoryToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(sessionHistory)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("Failed to save session history: \(error)")
        }
    }

    private func loadHistoryFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else { return }
        do {
            sessionHistory = try JSONDecoder().decode([WorkoutSession].self, from: data)
        } catch {
            print("Failed to load session history: \(error)")
        }
    }

    public func saveCurrentSession() {
        guard let session = currentSession else { return }
        do {
            let data = try JSONEncoder().encode(session)
            UserDefaults.standard.set(data, forKey: currentSessionKey)
        } catch {
            print("Failed to save current session: \(error)")
        }
    }
    private func loadCurrentSession() {
        guard let data = UserDefaults.standard.data(forKey: currentSessionKey) else { return }
        do {
            currentSession = try JSONDecoder().decode(WorkoutSession.self, from: data)
        } catch {
            print("Failed to load current session: \(error)")
        }
    }

    // Additional useful methods
    func removeExerciseFromCurrentSession(_ exercise: Exercise) {
        guard var session = currentSession else { return }
        session.removeWorkout(exercise)
        currentSession = session
        saveCurrentSession()
    }

    func getSessionTotalWorkouts() -> Int {
        return currentSession?.workouts.count ?? 0
    }

    func getTotalWorkoutTimeForCurrentSession() -> TimeInterval {
        return currentSession?.duration ?? 0
    }

    // Clear all session data
    func clearAllSessionData() {
        currentSession = nil
        sessionHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: currentSessionKey)
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
}
