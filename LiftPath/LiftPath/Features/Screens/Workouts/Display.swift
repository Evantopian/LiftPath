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
         NavigationStack {
             VStack(spacing: 0) {
                 // Modern Header Section
                 VStack(spacing: 10) {
                     HStack {
                         BackButtonView(color: .white)
                         Spacer()
                     }
                     
                     VStack(spacing: 5) {
                         Text(bodyPart.capitalized)
                             .font(.system(size: 32, weight: .bold, design: .rounded))
                             .foregroundColor(.white)
                         
                         Text("Exercises")
                             .font(.system(size: 18, weight: .medium, design: .rounded))
                             .foregroundColor(.white.opacity(0.8))
                     }
                     .padding()
                 }
                 .padding(.top, 10)
                 .background(
                     Rectangle()
                         .fill(LiftPathTheme.primaryGreen)
                         .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                 )
                 
                 // ScrollView with exercises
                 ScrollView {
                     LazyVStack(spacing: 15) {
                         ForEach(exercises) { exercise in
                             NavigationLink(destination: DisplayDetails(exercise: exercise)) {
                                 ExerciseRow(exercise: exercise)
                             }
                         }
                     }
                     .padding()
                 }
             }
             .background(Color.white)
             .onAppear {
                 loadExercises()
             }
             .navigationBarBackButtonHidden(true)
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
