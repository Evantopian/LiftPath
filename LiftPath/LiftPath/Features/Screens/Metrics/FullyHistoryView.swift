//
//  FullyHistoryView.swift
//  LiftPath
//
//  Created by Evan Huang on 12/8/24.
//

import SwiftUI

struct FullHistoryView: View {
    @ObservedObject var workoutSessionManager = WorkoutSessionManager.shared
    @Environment(\.presentationMode) var presentationMode // To manage the navigation stack

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back to the previous view
                    }) {
                        Image(systemName: "chevron.left") // Chevron symbol
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.leading, 10) // Moved closer to the left
                    }
                    Spacer()
                }
                .padding(.top, 10) // Moved chevron slightly higher
                Text("Full Workout History")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                ForEach(workoutSessionManager.sessionHistory, id: \.id) { session in
                    WorkoutHistoryCard(session: session)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity)
        }
        .background(LiftPathTheme.primaryGreen.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
}
