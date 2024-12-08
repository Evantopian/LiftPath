//
//  WorkoutSessionView.swift
//  LiftPath
//
//  Created by Evan Huang on 12/7/24.
//
import SwiftUI

struct WorkoutSessionView: View {
    @ObservedObject var userData = UserData.shared
    @State private var isSessionStarted: Bool = false
    @State private var currentSessionDuration: TimeInterval = 0
    @State private var timer: Timer?
    
    // Add a session property to the view
    var session: WorkoutSession?  // This will hold the session passed from the NavigationLink
    
    var body: some View {
        VStack {
            if let currentSession = session ?? userData.currentSession {
                sessionDetailsView(for: currentSession)
            } else {
                noSessionView()
            }
        }
        .navigationBarTitle("Workout Session", displayMode: .inline)
        .padding()
        .onAppear {
            if isSessionStarted {
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
                    Text("• \(workout.name)")
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
    }
    
    /// Displays a fallback view when no session is active
    private func noSessionView() -> some View {
        VStack {
            Text("No Active Session")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            Text("Start a new session to track your progress.")
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
            userData.currentSession?.duration = currentSessionDuration
        }
    }
    
    private func stopTimer() {
        // Stop the timer when the session ends
        timer?.invalidate()
        timer = nil
    }
    
    private func startNewSession() {
        userData.currentSession = WorkoutSession(sessionName: "New Session", workouts: [])
        isSessionStarted = true
        startTimer()
    }
}
