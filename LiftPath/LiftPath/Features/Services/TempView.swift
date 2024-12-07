//
// Features/Temp/TempView.swift
//  LiftPath
//
//  Created by Evan Huang on 11/11/24.
//

// not used atm, on hold
import SwiftUI

struct TempView: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(LiftPathTheme.primaryGreen)
            
            Text(title)
                .font(.title2)
                .bold()
                .padding(.top)
            
            Text("Coming Soon!")
                .foregroundColor(.gray)
                .padding(.top, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LiftPathTheme.primaryGreen.opacity(0.2))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
