//
//  DisplayDetails.swift
//  LiftPath
//
//  Created by Evan Huang on 12/2/24.
//

import SwiftUI

struct DisplayDetails: View {
    let exercise: Exercise
    @State private var isAddedToSession: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text(exercise.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()

            // Display Exercise Target
            Text("Target: \(exercise.target)")
                .font(.title2)
                .foregroundColor(.gray)

            // Async image for the exercise (Display GIF properly)
            AsyncImage(url: URL(string: exercise.gifUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
                    .frame(width: 300, height: 300)
            }

            // Add exercise to the current workout session
            Button(action: {
                // Check if there is a current session and add exercise to it
                WorkoutSessionManager.shared.addExerciseToCurrentSession(exercise)
                
                // Check if the exercise is already added to the session
                isAddedToSession = WorkoutSessionManager.shared.currentSession?.workouts.contains(where: { $0.id == exercise.id }) ?? false
            }) {
                HStack {
                    Image(systemName: isAddedToSession ? "checkmark" : "plus")
                        .foregroundColor(isAddedToSession ? .green : .blue)
                        .font(.title)
                    Text(isAddedToSession ? "Added to Workout Session" : "Add to Workout Session")
                        .font(.headline)
                        .foregroundColor(isAddedToSession ? .green : .blue)
                }
                .padding()
                .frame(width: 200, height: 50)
                .background(isAddedToSession ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                .cornerRadius(25)
                .overlay(
                    Circle()
                        .stroke(isAddedToSession ? Color.green : Color.blue, lineWidth: 2)
                )
            }
            .disabled(isAddedToSession) // Disable after adding to the session

            Spacer()
        }
        .navigationBarTitle("Exercise Details", displayMode: .inline)
        .padding()
    }
}
