//
//  Stats.swift
//  LiftPath
//
//  Created by Evan Huang on 11/25/24.
//
import SwiftUI

struct StatsView: View {
    @ObservedObject var workoutSessionManager = WorkoutSessionManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Workout Session History")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()

                        if workoutSessionManager.sessionHistory.isEmpty {
                            Text("No sessions completed yet.")
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            let sessionsToShow = Array(workoutSessionManager.sessionHistory.prefix(3))
                            
                            ForEach(sessionsToShow, id: \.id) { session in
                                WorkoutHistoryCard(session: session)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            
                            if workoutSessionManager.sessionHistory.count > 3 {
                                NavigationLink(destination: FullHistoryView()) {
                                    Text("See All")
                                        .font(.headline)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                        .foregroundColor(.white)
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                    .padding(.top)
                    .frame(maxWidth: .infinity)
                }
                .background(LiftPathTheme.primaryGreen.edgesIgnoringSafeArea(.all))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("LiftPath")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                            NavigationLink(destination: ProfileView()) {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
    }
}
