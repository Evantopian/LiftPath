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
        NavigationView {
            ZStack {
                LiftPathTheme.primaryGreen.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Metrics Card
                        WorkoutMetricsCard()
                            .padding(.horizontal)
                            .padding(.top)
                        
                        // Recent Sessions Section
                        recentSessionsSection
                    }
                }
            }
            .liftPathToolbar(textColor: LiftPathTheme.primaryGreen, iconColor: LiftPathTheme.primaryGreen)

        }
        .accentColor(LiftPathTheme.primaryGreen)
    }
    
    private var recentSessionsSection: some View {
        VStack(spacing: 15) {
            Text("Recent Workout Sessions")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(LiftPathTheme.primaryGreen)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            if workoutSessionManager.sessionHistory.isEmpty {
                emptyStateView
            } else {
                sessionsContent
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Image(systemName: "figure.strengthtraining.traditional")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(LiftPathTheme.primaryGreen.opacity(0.5))
            
            Text("No workout sessions yet")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.7))
        .cornerRadius(15)
    }
    
    private var sessionsContent: some View {
        VStack(spacing: 15) {
            let sessionsToShow = Array(workoutSessionManager.sessionHistory.prefix(3))
            
            ForEach(sessionsToShow, id: \.id) { session in
                WorkoutHistoryCard(session: session)
                    .padding(.horizontal)
            }
            
            if workoutSessionManager.sessionHistory.count > 3 {
                NavigationLink(destination: FullHistoryView()) {
                    Text("See All Sessions")
                        .font(.headline)
                        .padding()
                        .background(LiftPathTheme.primaryGreen)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
        }
    }
}
