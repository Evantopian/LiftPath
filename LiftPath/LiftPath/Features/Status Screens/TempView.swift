//
// Features/Temp/TempView.swift
//  LiftPath
//
//  Created by Evan Huang on 11/11/24.
//

import SwiftUI

struct TempView: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(LiftPathTheme.primaryGreen)
            
            Text(title)
                .font(.title2)
                .bold()
            
            Text("Coming Soon!")
                .foregroundColor(.gray)
        }
        .navigationTitle(title)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LiftPathTheme.primaryGreen.opacity(0.2))
    }
}
