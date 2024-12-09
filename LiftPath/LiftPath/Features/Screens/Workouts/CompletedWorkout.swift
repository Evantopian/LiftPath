// CompletionView.swift
// LiftPath
//
// Created by Evan Huang on 12/8/24.

import SwiftUI

struct CompletionView: View {
    @ObservedObject var sessionManager: WorkoutSessionManager
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToHome: Bool = false

    var body: some View {
        ZStack {
            LiftPathTheme.primaryGreen.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Animated Checkmark
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.3), radius: 10)
                
                // Session Details Card
                VStack(spacing: 15) {
                    Text(sessionManager.currentSession?.sessionName ?? "Workout Complete")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(LiftPathTheme.primaryGreen)
                    
                    Divider()
                    
                    // Detailed Session Stats
                    HStack(spacing: 20) {
                        // Duration Section
                        VStack(alignment: .center, spacing: 8) {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            
                            Text("Duration")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            Text(sessionManager.formattedDuration(sessionManager.currentSession?.duration ?? 0))
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Exercises Section
                        VStack(alignment: .center, spacing: 8) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(LiftPathTheme.primaryGreen)
                            
                            Text("Exercises")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            ScrollView {
                                VStack(alignment: .center, spacing: 4) {
                                    ForEach(sessionManager.currentSession?.workouts ?? []) { workout in
                                        Text(workout.name)
                                            .font(.system(size: 14, design: .rounded))
                                    }
                                }
                            }
                            .frame(maxHeight: 100)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // Return Home Button
                NavigationLink(destination: HomeView()) {
                    Button(action: exitSession) {
                        Text("Return Home")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LiftPathTheme.primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    private func exitSession() {
        sessionManager.completeCurrentSession()
        presentationMode.wrappedValue.dismiss()
    }
}
