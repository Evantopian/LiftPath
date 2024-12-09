//
//  ExceriseRow.swift
//  LiftPath
//
//  Created by Evan Huang on 12/8/24.
//
import SwiftUI

struct ExerciseRow: View {
    @State private var isFavorited: Bool
    @State private var isPlusButtonTapped = false
    let exercise: Exercise

    init(exercise: Exercise) {
        self.exercise = exercise
        _isFavorited = State(initialValue: UserData.shared.favoriteExercises.contains(where: { $0.id == exercise.id }))
    }

    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            // Exercise Image
            AsyncImage(url: URL(string: exercise.gifUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(LiftPathTheme.primaryGreen.opacity(0.2), lineWidth: 2)
                    )
            } placeholder: {
                ProgressView()
                    .frame(width: 90, height: 90)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }

            // Exercise Details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(exercise.name)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(LiftPathTheme.primaryGreen)
                        .lineLimit(2)

                    Spacer()

                    // Favorite Button
                    Button(action: {
                        isFavorited.toggle()
                        UserData.shared.toggleFavorite(for: exercise)
                    }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(isFavorited ? .red : LiftPathTheme.primaryGreen.opacity(0.5))
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                HStack(spacing: 8) {
                    Image(systemName: "target")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                    
                    Text(exercise.target)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 8) {
                    Image(systemName: "dumbbell")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                    
                    Text(exercise.equipment)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Spacer()

                    // Plus Button (which will turn into a checkmark)
                    Button(action: {
                        // Add exercise to session
                        WorkoutSessionManager.shared.addExerciseToCurrentSession(exercise)
                        
                        // Trigger tap animation
                        withAnimation(.spring()) {
                            isPlusButtonTapped = true
                        }

                        // Reset animation and icon after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.spring()) {
                                isPlusButtonTapped = false
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

        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
