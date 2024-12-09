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
    @State private var showCompletionAnimation: Bool = false
    @State private var isEditingSessionName: Bool = false
    @State private var newSessionName: String = ""
    @FocusState private var sessionNameFocused: Bool
    @State private var showOverlayMessage = false

    var session: WorkoutSession?
    
    var body: some View {
        NavigationStack {
            HStack {
                BackButtonView(color: LiftPathTheme.primaryGreen)
                Spacer()
            }
            .padding(.top, 10) // Moved chevron slightly higher
            ZStack {
                LiftPathTheme.primaryGreen.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                if showCompletionAnimation {
                    CompletionView(sessionManager: sessionManager)
                } else {
                    mainSessionContent
                }
            }
        }
        .accentColor(LiftPathTheme.primaryGreen)
        .navigationBarBackButtonHidden(true)
    }
    
    private var mainSessionContent: some View {
        ScrollView {
            VStack(spacing: 20) {
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
            .padding()
        }
    }
    
    private func sessionDetailsView(for session: WorkoutSession) -> some View {
        VStack(spacing: 20) {
            sessionNameSection(for: session)
            
            VStack(alignment: .leading, spacing: 15) {
                sessionInfoCard(for: session)
                exerciseListCard(for: session)
                
                VStack(spacing: 15) {
                    if session.isStarted {
                        completeSessionButton(session: session)
                        pauseContinueButton(session: session)
                    } else {
                        startSessionButton()
                    }
                }
                .padding(.top)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func sessionNameSection(for session: WorkoutSession) -> some View {
        HStack {
            if isEditingSessionName {
                TextField("Session Name", text: $newSessionName, onCommit: saveSessionName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($sessionNameFocused)
                    .onChange(of: sessionNameFocused) { _, isFocused in
                        if !isFocused { saveSessionName() }
                    }
            } else {
                Text(session.sessionName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(LiftPathTheme.primaryGreen)
            }
            
            Button(action: toggleSessionNameEditing) {
                Image(systemName: "pencil.circle.fill")
                    .foregroundColor(LiftPathTheme.primaryGreen)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
    }
    
    private func sessionInfoCard(for session: WorkoutSession) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            DetailRow(
                icon: "clock",
                title: "Session Duration",
                value: sessionManager.formattedDuration(session.duration),
                color: .blue
            )
        }
    }
    
    private func exerciseListCard(for session: WorkoutSession) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Exercises")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(LiftPathTheme.primaryGreen)
            
            ForEach(session.workouts) { workout in
                HStack {
                    Text("• \(workout.name)")
                        .font(.system(size: 16, design: .rounded))
                    
                    Spacer()
                    
                    Button(action: { sessionManager.removeExerciseFromCurrentSession(workout) }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
    
    private func completeSessionButton(session: WorkoutSession) -> some View {
        Button(action: completeSession) {
            Text("Complete Session")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private func pauseContinueButton(session: WorkoutSession) -> some View {
        Button(action: toggleSessionPause) {
            Text(session.isPaused ? "Continue Session" : "Pause Session")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(session.isPaused ? Color.blue : Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private func startSessionButton() -> some View {
        Button(action: startSession) {
            Text("Start Session")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LiftPathTheme.primaryGreen)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private func noSessionView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.strengthtraining.traditional")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(LiftPathTheme.primaryGreen.opacity(0.5))
            
            Text(sessionManager.sessionHistory.isEmpty ? "No Active Session" : "Start Another Session")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(LiftPathTheme.primaryGreen)
            
            Text(sessionManager.sessionHistory.isEmpty
                 ? "Start a new session to track your progress."
                 : "You have completed previous workout sessions.")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            NavigationLink(destination: HomeView()) {
                Button(action: showPleaseSelectMessage) {
                    HStack {
                        Text("Start New Session")
                        Image(systemName: "plus.circle.fill")
                    }
                    .font(.headline)
                    .padding()
                    .background(LiftPathTheme.primaryGreen)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.7))
        .cornerRadius(15)
        .overlay(
            Group {
                if showOverlayMessage {
                    Text("Please select some workouts")
                        .font(.caption)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        )
    }
    
    // MARK: - Action Methods
    private func toggleSessionNameEditing() {
        isEditingSessionName.toggle()
        if !isEditingSessionName {
            saveSessionName()
        }
    }
    
    private func saveSessionName() {
        sessionManager.changeSessionName(newName: newSessionName)
        isEditingSessionName = false
    }
    
    private func showPleaseSelectMessage() {
        showOverlayMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showOverlayMessage = false
        }
    }
    
    private func startSession() {
        sessionManager.startSession()
    }
    
    private func toggleSessionPause() {
        guard let session = sessionManager.currentSession else { return }
        if session.isPaused {
            resumeSession()
        } else {
            pauseSession()
        }
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
}
