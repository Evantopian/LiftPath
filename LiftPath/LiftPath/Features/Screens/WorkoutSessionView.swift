//
//  WorkoutSessionView.swift
//  LiftPath
//
//  Created by Evan Huang on 12/7/24.
import SwiftUI

struct WorkoutSessionView: View {
    @ObservedObject private var sessionManager = WorkoutSessionManager.shared
    @State private var isSessionStarted: Bool = false
    @State private var currentSessionDuration: TimeInterval = 0
    @State private var timer: Timer?
    
    // Add a session property to the view
    var session: WorkoutSession?  // This will hold the session passed from the NavigationLink
    
    var body: some View {
        
        VStack {
            if let currentSession = session ?? sessionManager.currentSession {
                sessionDetailsView(for: currentSession)
            } else {
                noSessionView()
            }
        }
        .navigationBarTitle("Workout Session", displayMode: .inline)
        .padding()
        .onAppear {
            if let currentSession = session ?? sessionManager.currentSession {
                print("Session Name: \(currentSession.sessionName)")
                print("Duration: \(formattedDuration(currentSession.duration))")
                print("Workouts:")
                for workout in currentSession.workouts {
                    print("- \(workout.name)")
                }
            } else {
                print("No active session.")
            }
            
            if sessionManager.currentSession != nil {
                isSessionStarted = true
                startTimer()
            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - Helper Views
    
    /// Displays the session details including name, time, and workouts
    private func sessionDetailsView(for session: WorkoutSession) -> some View {
        VStack(spacing: 20) {
            Text(session.sessionName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Session Duration: \(formattedDuration(session.duration))")
                
                Divider()
                
                // Display workouts in the session
                Text("Workouts")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                ForEach(session.workouts) { workout in
                    HStack {
                        Text("• \(workout.name)")
                        Spacer()
                        Button(action: {
                            sessionManager.removeExerciseFromCurrentSession(workout)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                // Complete Session Button
                Button(action: {
                    stopTimer()
                    sessionManager.completeCurrentSession()
                }) {
                    Text("Complete Session")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
        }
    }
    
    /// Displays a fallback view when no session is active
    private func noSessionView() -> some View {
        VStack {
            Text(sessionManager.sessionHistory.isEmpty ? "No Active Session" : "Start Another Session")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            Text(sessionManager.sessionHistory.isEmpty
                 ? "Start a new session to track your progress."
                 : "You have completed previous workout sessions.")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
            
            Button(action: {
                startNewSession()
            }) {
                HStack {
                    Text("Start New Session")
                    Image(systemName: "plus.circle.fill")
                }
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }

    // MARK: - Helper Functions
    
    private func formattedDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        // Start a timer to update the session duration continuously
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentSessionDuration += 1
            sessionManager.currentSession?.duration = currentSessionDuration
            sessionManager.saveCurrentSession()
        }
    }
    
    private func stopTimer() {
        // Stop the timer when the session ends
        timer?.invalidate()
        timer = nil
    }
    
    private func startNewSession() {
        sessionManager.startNewSession()
        isSessionStarted = true
        currentSessionDuration = 0
        startTimer()
    }
}
