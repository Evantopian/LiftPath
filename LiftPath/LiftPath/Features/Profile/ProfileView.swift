//
// Features/Profile/ProfileView.swift
//  LiftPath
//
//  Created by Evan Huang on 11/11/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Card
                ProfileCardView(
                    username: viewModel.username,
                    rank: viewModel.rank,
                    bio: viewModel.bio,
                    stats: viewModel.stats
                )
                
                // Activity Heatmap
                ActivityHeatmapView(activities: viewModel.activityData)
            }
            .padding()
        }
        .background(LiftPathTheme.primaryGreen.opacity(0.2))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileCardView: View {
    let username: String
    let rank: Int
    let bio: String
    let stats: ProfileStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Profile Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(username)
                        .font(.title2)
                        .bold()
                    Text("Rank #\(rank)")
                        .foregroundColor(.orange)
                    
                    Text(bio)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Divider()
            
            // Stats Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                StatItemView(value: stats.completed, label: "Completed")
                StatItemView(value: stats.streak, label: "Current Streak")
                StatItemView(value: stats.monthlyGoal, label: "Monthly Goal")
                StatItemView(value: stats.totalMinutes, label: "Total Minutes")
            }
        }
        .padding()
        .liftPathCard()
    }
}

struct ActivityHeatmapView: View {
    let activities: [[Bool]]
    let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Activity")
                .font(.title2)
                .bold()
            
            VStack(alignment: .leading, spacing: 4) {
                // Weekday labels
                HStack(spacing: 4) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(.caption2)
                            .frame(width: 20)
                    }
                }
                
                // Activity grid
                ForEach(0..<activities.count, id: \.self) { week in
                    HStack(spacing: 4) {
                        ForEach(0..<activities[week].count, id: \.self) { day in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(activities[week][day] ?
                                      LiftPathTheme.primaryGreen :
                                      Color.gray.opacity(0.2))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
        }
        .padding()
        .liftPathCard()
    }
}

struct StatItemView: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(value)")
                .font(.title2)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// ViewModel
class ProfileViewModel: ObservableObject {
    @Published var username: String = "TempName"
    @Published var rank: Int = 1234
    @Published var bio: String = "blurb of information. (max 100 characters)?"
    @Published var stats = ProfileStats(
        completed: 59,
        streak: 12,
        monthlyGoal: 20,
        totalMinutes: 1240
    )
    @Published var activityData: [[Bool]] = []
    
    init() {
        generateActivityData()
    }
    
    private func generateActivityData() {
        activityData = (0..<12).map { _ in
            (0..<7).map { _ in Bool.random() }
        }
    }
}

struct ProfileStats {
    let completed: Int
    let streak: Int
    let monthlyGoal: Int
    let totalMinutes: Int
}
