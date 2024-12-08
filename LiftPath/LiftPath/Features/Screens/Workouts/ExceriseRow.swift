//
//  ExceriseRow.swift
//  LiftPath
//
//  Created by Evan Huang on 12/8/24.
//

import SwiftUI

struct ExerciseRow: View {
    @State private var isFavorited: Bool
    let exercise: Exercise

    init(exercise: Exercise) {
        self.exercise = exercise
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
                UserData.shared.toggleFavorite(for: exercise)
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
