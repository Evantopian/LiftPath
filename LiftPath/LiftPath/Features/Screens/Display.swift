// Display.swift
// LiftPath
//
// Created by Evan Huang on 11/25/24.
//

import SwiftUI

struct Display: View {
    let bodyPart: String
    @State private var exercises: [Exercise] = []

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
                if exercises.isEmpty {
                    fetchExercises()
                }
            }
        }
    }

    func fetchExercises() {
        ExerciseAPIFetcher.fetchExercises(for: bodyPart) { fetchedExercises in
            self.exercises = fetchedExercises
        }
    }
}

struct ExerciseRow: View {
    @State private var isFavorited: Bool = false
    let exercise: Exercise

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
