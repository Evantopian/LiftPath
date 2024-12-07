//
//  ProfileModel.swift
//  LiftPath
//
//  Created by Evan Huang on 12/6/24.
//

import Foundation

struct ProfileStats {
    let completed: Int
    let streak: Int
    let monthlyGoal: Int
    let totalMinutes: Int
}

class ProfileViewModel: ObservableObject {
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
