//
//  WorkoutMetricsCard.swift
//  LiftPath
//
//  Created by Evan Huang on 12/9/24.
//

import SwiftUI

struct WorkoutMetricsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your Workout Insights")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(LiftPathTheme.primaryGreen)
            
            HStack(spacing: 15) {
                MetricItem(
                    icon: "clock",
                    title: "Avg Duration",
                    value: "45 mins",
                    color: .blue
                )
                
                MetricItem(
                    icon: "repeat",
                    title: "Workouts/Week",
                    value: "3.5",
                    color: .purple
                )
            }
            
            HStack(spacing: 15) {
                MetricItem(
                    icon: "flame",
                    title: "Total Calories",
                    value: "2,345",
                    color: .orange
                )
                
                MetricItem(
                    icon: "chart.bar",
                    title: "Progress",
                    value: "+12%",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct MetricItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .imageScale(.large)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}
