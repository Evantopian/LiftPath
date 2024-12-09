//
//  WorkoutHistoryCard.swift
//  LiftPath
//
//  Created by Evan Huang on 12/9/24.
//

import SwiftUI

struct WorkoutHistoryCard: View {
    @State private var isFavorited: Bool
    let session: WorkoutSession

    init(session: WorkoutSession) {
        self.session = session
        // Check if the session's ID is in the favoritedSessions list
        _isFavorited = State(initialValue: UserData.shared.favoritedSessions.contains(session.id))
    }

    var body: some View {
        VStack {
            HStack {
                Text(session.sessionName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

                Button(action: {
                    // Toggle the favorite status for the session
                    isFavorited.toggle()
                    UserData.shared.toggleFavorite(for: session.id)
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(isFavorited ? .red : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Duration: \(String(format: "%.2f", session.duration / 60)) mins")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(session.isCompleted ? "Completed" : "In Progress")
                    .font(.subheadline)
                    .foregroundColor(session.isCompleted ? .green : .orange)
            }
            .padding(.top, 4)

            // Optionally show details of the session like exercises, etc.
            // For example:
            Text("Exercises: \(session.workouts.count)")
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.top, 8)

            Divider()
        }
        .padding()
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
