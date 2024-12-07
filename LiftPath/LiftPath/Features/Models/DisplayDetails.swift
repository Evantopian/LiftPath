//
//  DisplayDetails.swift
//  LiftPath
//
//  Created by Evan Huang on 12/2/24.
//

import SwiftUI

struct DisplayDetails: View {
    let exercise: Exercise

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

            // Async image for the exercise
            AsyncImage(url: URL(string: exercise.gifUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
                    .frame(width: 300, height: 300)
            }

            Spacer()
        }
        .navigationBarTitle("Exercise Details", displayMode: .inline)
        .padding()
    }
}
