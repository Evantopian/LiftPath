//
//  ResumeBox.swift
//  LiftPath
//
//  Created by Evan Huang on 12/8/24.
//
import SwiftUI

struct ResumeBoxView: View {
    let username: String
    let workoutTitle: String?
    let session: WorkoutSession? // Optional, as there may be no active session

    var body: some View {
        VStack {
            if let session = session {
                // Case: There is an ongoing workout session
                VStack(alignment: .leading, spacing: 15) {
                    // The whole view is now wrapped in a NavigationLink to make it tappable
                    NavigationLink(destination: WorkoutSessionView(session: session)) {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "dumbbell.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.black)
                                    .padding()

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Continue Training, \(username)?")
                                        .font(.headline)
                                        .bold()

                                    Text(workoutTitle ?? "Your Custom Workout")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }

                            // Progress Bar
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Progress")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                ProgressView(value: 0.75) // Hardcoded progress for now
                                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle()) // Use this to remove the default NavigationLink style
                }
            } else {
                // Case: No ongoing workout session
                VStack(alignment: .center, spacing: 15) {
                    Image(systemName: "lightbulb.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.yellow)
                        .padding()

                    Text("Let's Craft A Workout Session, \(username)!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    // NavigationLink to create a new session
                    NavigationLink(destination: WorkoutSessionView(session: WorkoutSession(sessionName: "Default Session", workouts: []))) {
                        Text("Start Now")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
            }
        }
    }
}
