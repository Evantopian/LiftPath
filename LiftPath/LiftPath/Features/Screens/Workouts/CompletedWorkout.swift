// CompletionView.swift
// LiftPath
//
// Created by Evan Huang on 12/8/24.

import SwiftUI

struct CompletionView: View {
    @ObservedObject var sessionManager: WorkoutSessionManager
    @Environment(\.presentationMode) var presentationMode // To dismiss the current view
    @State private var navigateToHome: Bool = false // Control the navigation

    var body: some View {
        VStack {
            // Animated Checkmark
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .transition(.scale)
                .padding()
            
            // Details Slide-Up
            VStack {
                Text(sessionManager.currentSession?.sessionName ?? "Workout Complete")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Duration")
                            .font(.headline)
                        Text("\(sessionManager.formattedDuration(sessionManager.currentSession?.duration ?? 0))")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Workouts")
                            .font(.headline)
                        ScrollView {
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(sessionManager.currentSession?.workouts ?? []) { workout in
                                    Text("• \(workout.name)")
                                }
                            }
                        }
                        .frame(maxHeight: 100) // Constrain scrollable height
                    }
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding()
            
            // Return Home Button
            NavigationLink(destination: HomeView()) {
                Button(action: {
                    exitSession()
                }) {
                    Text("Return Home")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }

    private func exitSession() {
        sessionManager.completeCurrentSession()
        presentationMode.wrappedValue.dismiss()
    }
}
