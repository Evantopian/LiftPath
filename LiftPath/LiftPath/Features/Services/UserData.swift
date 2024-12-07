//
//  UserData.swift
//  LiftPath
//
//  Created by Evan Huang on 12/2/24.
//

import Foundation
import SwiftUI

class UserData: ObservableObject {
    // Singleton instance for app-wide access
    static let shared = UserData()
    
    // UserDefaults keys
    private let usernameKey = "LiftPath_Username"
    private let ageKey = "LiftPath_Age"
    private let startDateKey = "LiftPath_StartDate"
    
    // Published properties
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: usernameKey)
        }
    }
    
    @Published var age: Int {
        didSet {
            UserDefaults.standard.set(age, forKey: ageKey)
        }
    }
    
    @Published var startDate: Date {
        didSet {
            UserDefaults.standard.set(startDate, forKey: startDateKey)
        }
    }
    
    // Private initializer to enforce singleton pattern
    private init() {
        // Load persisted data
        username = UserDefaults.standard.string(forKey: usernameKey) ?? ""
        age = UserDefaults.standard.integer(forKey: ageKey)
        
        // If no start date is saved, use current date
        if let savedDate = UserDefaults.standard.object(forKey: startDateKey) as? Date {
            startDate = savedDate
        } else {
            startDate = Date()
        }
    }
    
    func getFormattedStartDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter.string(from: startDate)
    }
    
    func clearAllUserData() {
        let defaults = UserDefaults.standard
        let keys = [usernameKey, ageKey, startDateKey]
        
        keys.forEach { defaults.removeObject(forKey: $0) }
        
        // Reset properties
        username = ""
        age = 0
        startDate = Date()
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
    }
}
