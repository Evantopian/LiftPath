// Display.swift
// LiftPath
//
// Created by Evan Huang on 11/25/24.
//

import SwiftUI

struct Display: View {
    let bodyPart: String
    @State private var exercises: [Exercise] = []
    @State private var userData = UserData.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Spacer()
                Text("Exercises for \(bodyPart.capitalized)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(LiftPathTheme.primaryGreen)
                    .multilineTextAlignment(.center)
                Spacer()

                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(exercises) { exercise in
                            NavigationLink(destination: DisplayDetails(exercise: exercise)) {
                                ExerciseRow(exercise: exercise)
                            }
                        }
                    }
                }
            }
            .background(LiftPathTheme.primaryGreen.edgesIgnoringSafeArea(.all))
            .onAppear {
                loadExercises()
            }
        }
    }

    func loadExercises() {
        if let cachedExercises = userData.exerciseCache[bodyPart], !cachedExercises.isEmpty {
            print("Retrieving exercises for \(bodyPart) from cache.")
            self.exercises = cachedExercises
        } else {
            print("No cached exercises found for \(bodyPart), calling API.")
            fetchExercises()
        }
    }

    func fetchExercises() {
        ExerciseAPIFetcher.fetchExercises(for: bodyPart) { fetchedExercises in
            DispatchQueue.main.async {
                self.exercises = fetchedExercises
                userData.addExercises(for: bodyPart, exercises: fetchedExercises)
            }
        }
    }
}

