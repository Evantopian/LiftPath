//
//  LiftPathApp.swift
//  LiftPath
//
//  Created by Evan Huang on 11/6/24.
//

import SwiftUI

@main
struct LiftPathApp: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @StateObject private var userData = UserData.shared

    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                InitialSetupView()
            } else {
                ContentView()
            }
        }
    }
}

