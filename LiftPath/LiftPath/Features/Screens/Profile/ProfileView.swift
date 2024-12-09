//
// Features/Profile/ProfileView.swift
//  LiftPath
//
//  Created by Evan Huang on 11/11/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var userData = UserData.shared
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack{
                    BackButtonView(color: .white)
                    Spacer()

                }
                .padding(.top, 10)
                // Profile Card
                ProfileCardView(
                    username: userData.username,
                    bio: viewModel.bio,
                    stats: viewModel.stats
                )
                
                // Activity Heatmap
                ActivityHeatmapView(activities: viewModel.activityData)
                
                // Clear Data Button
                Button(action: {
                    showingConfirmation = true
                }) {
                    Text("Clear All User Data")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .confirmationDialog("Are you sure?",
                    isPresented: $showingConfirmation,
                    titleVisibility: .visible) {
                    Button("Clear All Data", role: .destructive) {
                        userData.clearAllUserData()
                        // Reset to first launch
                        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                        // Dismiss current view and go back to initial setup
                    }
                }
            }
            .padding()
        }
        .background(LiftPathTheme.primaryGreen)
        .navigationBarBackButtonHidden(true)
    }
}


struct ProfileCardView: View {
    let username: String
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
            
            VStack(alignment: .leading, spacing: 8) {
                // Weekday labels
                HStack(spacing: 8) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(.caption2)
                            .frame(width: 30)
                    }
                }
                
                ForEach(0..<activities.count, id: \.self) { week in
                    HStack(spacing: 8) {
                        ForEach(0..<activities[week].count, id: \.self) { day in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(activities[week][day] ?
                                      LiftPathTheme.primaryGreen :
                                      Color.gray.opacity(0.2))
                                .frame(width: 30, height: 20)
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
