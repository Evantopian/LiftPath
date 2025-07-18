//
// Features/Home/HomeView.swift
//  LiftPath
//
//  Created by Evan Huang on 11/8/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedTab: String = "dumbbell.fill"
    @StateObject private var userData = UserData.shared
    @ObservedObject private var sessionManager = WorkoutSessionManager.shared
    
    var body: some View {
           NavigationStack {
               ZStack {
                   ScrollView {
                       VStack(spacing: 20) {
                           // Pass the current session directly from sessionManager
                           ResumeBoxView(
                               username: userData.username,
                               workoutTitle: sessionManager.currentSession?.sessionName,
                               session: sessionManager.currentSession
                           )

                           // Featured Section
                           WorkoutSectionView(title: "Featured", workouts: viewModel.featuredWorkouts)

                           // Other Workouts Section
                           WorkoutSectionView(title: "Other", workouts: viewModel.otherWorkouts)
                       }
                       .padding()
                   }
                   .background(LiftPathTheme.primaryGreen)
                   .liftPathToolbar(textColor: .white, iconColor: .white)
               }
               .accentColor(LiftPathTheme.primaryGreen)
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
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("See All") {
                }
                .foregroundColor(LiftPathTheme.primaryGreen)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .font(.caption)
                .frame(width: 60)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)


            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(workouts) { workout in
                        WorkoutCategoryCard(category: workout)
                            .frame(width: 200, height: 160)
                    }
                }
            }
        }
    }
}

struct WorkoutCategoryCard: View {
    let category: WorkoutCategory
    
    var body: some View {
        NavigationLink(destination: Display(bodyPart: category.name)) {
            VStack {
                Image(systemName: category.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                    .padding()
                    .foregroundColor(LiftPathTheme.primaryGreen)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
                    .padding(.horizontal)
                
                Text(category.name)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity)
            .liftPathCard()
        }
    }
}
