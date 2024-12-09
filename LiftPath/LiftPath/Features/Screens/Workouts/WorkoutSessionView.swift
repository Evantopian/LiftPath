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
    @State private var isEditingSessionName: Bool = false  // To track if session name is being edited
    @State private var newSessionName: String = ""  // To store the new session name
    @FocusState private var sessionNameFocused: Bool  // To track if the session name field is focused
    @State private var showOverlayMessage = false // State to show/hide the overlay message

    
    var session: WorkoutSession?  // This will hold the session passed from the NavigationLink
    
    var body: some View {
        VStack {
            if showCompletionAnimation {
                CompletionView(sessionManager: sessionManager)
            } else {
                if let currentSession = session ?? sessionManager.currentSession {
                    if currentSession.workouts.count >= 1 {
                        sessionDetailsView(for: currentSession)
                    } else {
                        noSessionView()
                    }
                } else {
                    noSessionView()
                }
            }
        }

        .padding()
        .onAppear {
            if let existingSession = sessionManager.currentSession {
                isSessionPaused = existingSession.isPaused
                newSessionName = existingSession.sessionName // Initialize the new session name
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func sessionDetailsView(for session: WorkoutSession) -> some View {
        VStack(spacing: 20) {
            HStack{
                BackButtonView(color: LiftPathTheme.primaryGreen)
                Spacer()

            }
            .padding(.top, 10)
            HStack {
                if isEditingSessionName {
                    TextField("Session Name", text: $newSessionName, onCommit: {
                        saveSessionName()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($sessionNameFocused) // Bind the focus state to manage focus
                    .onChange(of: sessionNameFocused) { _, isFocused in
                        if !isFocused {
                            saveSessionName()  // Save when focus is lost
                        }
                    }
                    .padding()
                } else {
                    Text(session.sessionName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }
                
                Button(action: {
                    isEditingSessionName.toggle()
                    if !isEditingSessionName {
                        saveSessionName() // Save when switching off editing mode
                    }
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Session Duration: \(sessionManager.formattedDuration(session.duration))")
                
                Divider()
                
                // Display workouts in the session
                Text("Exercises")
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
        .navigationBarBackButtonHidden(true)
    }
    
    
    private func noSessionView() -> some View {
        return ZStack {
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
                
                NavigationLink(destination: HomeView()) {
                    Button(action: {
                        showOverlayMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showOverlayMessage = false // Hide overlay after 2.5 seconds
                        }
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
            
            // Overlay message
            if showOverlayMessage {
                VStack {
                    Text("Please select some workouts.")
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3)) // Optional dim background
                .transition(.opacity) // Smooth fade-in/out animation
            }
        }
        .animation(.easeInOut, value: showOverlayMessage) // Animate overlay appearance/disappearance
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
    
    // Method to save the new session name
    private func saveSessionName() {
        sessionManager.changeSessionName(newName: newSessionName)
        isEditingSessionName = false
    }
}
