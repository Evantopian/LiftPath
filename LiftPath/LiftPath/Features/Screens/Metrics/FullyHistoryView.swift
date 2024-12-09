//
//  FullyHistoryView.swift
//  LiftPath
//
//  Created by Evan Huang on 12/8/24.
//

import SwiftUI

struct FullHistoryView: View {
    @ObservedObject var workoutSessionManager = WorkoutSessionManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Workout History")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}
