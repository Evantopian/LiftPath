//
// Features/Home/HomeView.swift
//  LiftPath
//
//  Created by Evan Huang on 11/8/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Summary Card
                    ProfileSummaryView(username: viewModel.username,
                                     completedWorkouts: viewModel.completedWorkouts,
                                     streakDays: viewModel.streakDays)
                    
                    // Featured Section
                    WorkoutSectionView(title: "Featured",
                                     workouts: viewModel.featuredWorkouts)
                    
                    // Other Workouts Section
                    WorkoutSectionView(title: "Other",
                                     workouts: viewModel.otherWorkouts)
                }
                .padding()
            }
            .background(LiftPathTheme.primaryGreen.opacity(0.2))
            .navigationTitle("LiftPath Explore")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            // Tab Bar
            .safeAreaInset(edge: .bottom) {
                CustomTabBar()
            }
        }
    }
}
// Supporting Views
struct ProfileSummaryView: View {
    let username: String
    let completedWorkouts: Int
    let streakDays: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(username)
                        .font(.title2)
                        .bold()
                    
                    Button("Edit Profile") {
                        // Edit profile action
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(LiftPathTheme.primaryGreen)
                    .cornerRadius(15)
                }
                
                Spacer()
            }
            
            HStack {
                StatView(value: completedWorkouts, label: "Completed")
                Spacer()
                StatView(value: streakDays, label: "Streak Days")
            }
        }
        .padding()
        .liftPathCard()
    }
}

struct StatView: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.title)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct WorkoutSectionView: View {
    let title: String
    let workouts: [WorkoutCategory]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button("See All") {
                    // Action for see all
                }
                .foregroundColor(LiftPathTheme.primaryGreen)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(workouts) { workout in
                        WorkoutCategoryCard(category: workout)
                            .frame(width: 160, height: 160) // Fixed size here instead
                    }
                }
            }
        }
    }
}


struct WorkoutCategoryCard: View {
    let category: WorkoutCategory
    
    var body: some View {
        VStack {
            Image(systemName: category.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .padding()
            
            Text(category.name)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity)
        .liftPathCard()
    }
}


struct CustomTabBar: View {
    @State private var selectedTab: String? = nil
    
    let tabs = [
        (icon: "dumbbell.fill", title: "Workouts"),
        (icon: "figure.walk", title: "Progress"),
        (icon: "heart.circle.fill", title: "Health"),
        (icon: "chart.bar.fill", title: "Stats")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.icon) { tab in
                NavigationLink(value: tab.icon) {
                    Image(systemName: tab.icon)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(selectedTab == tab.icon ? LiftPathTheme.primaryGreen : .black)
                }
            }
        }
        .navigationDestination(for: String.self) { icon in
            TempView(icon: icon, title: tabs.first { $0.icon == icon }?.title ?? "")
        }
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal)
        .shadow(radius: 2)
    }
}
