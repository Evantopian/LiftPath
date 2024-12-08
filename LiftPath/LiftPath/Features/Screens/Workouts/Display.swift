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


struct ExerciseRow: View {
    @State private var isFavorited: Bool
    let exercise: Exercise

    init(exercise: Exercise) {
        self.exercise = exercise
        // Initialize the favorite state by checking if the exercise is in the favoriteExercises array
        _isFavorited = State(initialValue: UserData.shared.favoriteExercises.contains(where: { $0.id == exercise.id }))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: exercise.gifUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 80, height: 80)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(exercise.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(2)

                Text(exercise.target)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: {
                isFavorited.toggle()
                UserData.shared.toggleFavorite(for: exercise) // Update the favorites in UserData
            }) {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .font(.system(size: 24))
                    .foregroundColor(isFavorited ? .red : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
