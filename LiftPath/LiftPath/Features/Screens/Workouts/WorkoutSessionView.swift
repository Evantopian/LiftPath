//
//  WorkoutSessionView.swift
//  LiftPath
//
//  Created by Evan Huang on 12/7/24.
// WorkoutSessionView.swift
// LiftPath
//
// Created by Evan Huang on 12/7/24.

import SwiftUI

struct WorkoutSessionView: View {
    @ObservedObject private var sessionManager = WorkoutSessionManager.shared
    @State private var isSessionPaused: Bool = false
    @State private var showCompletionAnimation: Bool = false // Track completion state
    
    var session: WorkoutSession?  // This will hold the session passed from the NavigationLink
    
    var body: some View {
        VStack {
            if showCompletionAnimation {
                CompletionView(sessionManager: sessionManager)
            } else {
                if let currentSession = session ?? sessionManager.currentSession {
                    sessionDetailsView(for: currentSession)
                } else {
                    noSessionView()
                }
            }
        }
        .navigationBarTitle("Workout Session", displayMode: .inline)
        .padding()
        .onAppear {
            if let existingSession = sessionManager.currentSession {
                isSessionPaused = existingSession.isPaused
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func sessionDetailsView(for session: WorkoutSession) -> some View {
        VStack(spacing: 20) {
            Text(session.sessionName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Session Duration: \(sessionManager.formattedDuration(session.duration))")
                
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
                if session.isStarted {
                    Button(action: {
                        completeSession()
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
                
                // Pause/Continue Button
                if session.isStarted && !session.isCompleted {
                    Button(action: {
                        if session.isPaused {
                            resumeSession()
                        } else {
                            pauseSession()
                        }
                    }) {
                        Text(session.isPaused ? "Continue Session" : "Pause Session")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(session.isPaused ? Color.blue : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                } else {
                    Button(action: {
                        startSession()
                    }) {
                        Text("Start Session")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
    }
    
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
    
    private func startSession() {
        sessionManager.startSession()  // Start the timer only
    }
    
    private func pauseSession() {
        isSessionPaused = true
        sessionManager.pauseCurrentSession()
    }
    
    private func resumeSession() {
        isSessionPaused = false
        sessionManager.resumeCurrentSession()
    }
    
    private func completeSession() {
        withAnimation(.easeInOut(duration: 1)) {
            showCompletionAnimation = true
        }
        isSessionPaused = true
        sessionManager.pauseCurrentSession()
    }

    private func startNewSession() {
        sessionManager.createSession()
    }
}
