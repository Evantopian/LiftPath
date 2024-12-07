//
//  Stats.swift
//  LiftPath
//
//  Created by Evan Huang on 11/25/24.
//

import SwiftUI

struct StatsView: View {
    @State private var selectedTab: String = "chart.bar.fill"

    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Load Metrics Here.")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()

                        // Add other content if needed
                    }
                    .padding(.top) // Optional: only adds top padding
                    .frame(maxWidth: .infinity) // Ensures content fills the width of the screen
                }
                .background(LiftPathTheme.primaryGreen)
                .edgesIgnoringSafeArea(.horizontal) // Ensure content stretches across the screen
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
