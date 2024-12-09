//
//  WorkoutHistoryCard.swift
//  LiftPath
//
//  Created by Evan Huang on 12/9/24.
//

import SwiftUI

struct WorkoutHistoryCard: View {
    @State private var isFavorited: Bool
    @State private var isPlusButtonTapped = false
    @ObservedObject var workoutSessionManager = WorkoutSessionManager.shared
    let session: WorkoutSession
    
    init(session: WorkoutSession) {
        self.session = session
        // Check if the session's ID is in the favoritedSessions list
        _isFavorited = State(initialValue: UserData.shared.favoritedSessions.contains(session.id))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header with Session Name and Favorite Button
            HStack {
                Text(session.sessionName)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(LiftPathTheme.primaryGreen)

                Spacer()

                Button(action: {
                    // Toggle the favorite status for the session
                    isFavorited.toggle()
                    UserData.shared.toggleFavorite(for: session.id)
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(isFavorited ? .red : LiftPathTheme.primaryGreen.opacity(0.5))
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Workout Details
            VStack(alignment: .leading, spacing: 8) {
                DetailRow(
                    icon: "clock",
                    title: "Duration",
                    value: "\(String(format: "%.2f", session.duration / 60)) mins",
                    color: .blue
                )

                DetailRow(
                    icon: "checkmark.circle",
                    title: "Status",
                    value: session.isCompleted ? "Completed" : "In Progress",
                    color: session.isCompleted ? .green : .orange
                )

                HStack {
                    DetailRow(
                        icon: "list.bullet",
                        title: "Exercises",
                        value: "\(session.workouts.count)",
                        color: LiftPathTheme.primaryGreen
                    )
                    
                    Spacer()
                    
                    Button(action: {
                        // Trigger tap animation
                        withAnimation(.spring()) {
                            isPlusButtonTapped = true
                        }
                        
                        // Reset animation after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.spring()) {
                                isPlusButtonTapped = false
                            }
                        }
                        
                        // Check if there's an active session
                        if workoutSessionManager.currentSession != nil {
                            for workout in session.workouts {
                                workoutSessionManager.addExerciseToCurrentSession(workout)
                            }
                        } else {
                            workoutSessionManager.createSession(sessionName: "Copy of \(session.sessionName)")
                            for workout in session.workouts {
                                workoutSessionManager.addExerciseToCurrentSession(workout)
                            }
                        }
                    }) {
                        Image(systemName: isPlusButtonTapped ? "checkmark" : "plus")
                            .font(.system(size: 15, weight: .bold))  // Slightly smaller icon
                            .foregroundColor(LiftPathTheme.primaryGreen)
                            .padding(5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(LiftPathTheme.primaryGreen, lineWidth: 1.5)
                            )
                            .scaleEffect(isPlusButtonTapped ? 0.9 : 1.0)  // Scale animation
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Helper View for Detail Rows
struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 22)  // Slightly smaller frame

            Text("\(title): ")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)

            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(color)
        }
    }
}
