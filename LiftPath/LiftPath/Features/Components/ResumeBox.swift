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
            VStack(alignment: .leading, spacing: 15) {
                // Headline and Icon
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(headlineText)
                            .font(.headline)
                            .bold()

                        Text(workoutTitle ?? "Your Custom Workout")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: session == nil ? "lightbulb.fill" : "dumbbell.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(session == nil ? .yellow : .black)
                        .padding()
                }

                // Progress Bar (Only when there's a session)
                if let session = session, session.isStarted {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Progress")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        ProgressView(value: 0.75) // Hardcoded progress for now
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    }
                    .padding(.horizontal)
                }

                // Button
                NavigationLink(destination: WorkoutSessionView(session: session ?? WorkoutSession(sessionName: "Default Session", workouts: []))) {
                    Text(buttonText)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(buttonBackgroundColor)
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

    // MARK: - Computed UI Text and Colors

    private var headlineText: String {
        if session == nil {
            return "Let's Craft A Workout Session, \(username)!"
        } else if session?.isStarted == false {
            return "Let's Begin, \(username)!"
        } else {
            return "Continue Training, \(username)?"
        }
    }

    private var buttonText: String {
        if session == nil {
            return "Start Now"
        } else if session?.isStarted == false {
            return "Let's Begin"
        } else {
            return "Continue"
        }
    }

    private var buttonBackgroundColor: Color {
        if session == nil || session?.isStarted == false {
            return .green
        } else {
            return .blue
        }
    }
}
