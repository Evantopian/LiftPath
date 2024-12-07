//
//  InitView.swift
//  LiftPath
//
//  Created by Evan Huang on 12/7/24.
//

import SwiftUI

struct InitialSetupView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @StateObject private var viewModel = InitialSetupViewModel()

    var body: some View {
        ZStack {
            LiftPathTheme.primaryGreen.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image(systemName: "dumbbell.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)

                Text("Welcome to LiftPath")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Let's set up your profile")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Choose Your Username")
                        .font(.headline)
                        .foregroundColor(.white)

                    TextField("Enter your username", text: $viewModel.username)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.25))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .accentColor(.white)

                    Text("Enter Your Age")
                        .font(.headline)
                        .foregroundColor(.white)

                    TextField("Enter your age", text: $viewModel.age)
                        .keyboardType(.numberPad)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.25))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .accentColor(.white)

                    if viewModel.showError {
                        Text("Please fill out all fields correctly")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding()

                Button(action: {
                    viewModel.saveProfileData()
                    isFirstLaunch = false // Update AppStorage here
                }) {
                    Text("Get Started")
                        .fontWeight(.bold)
                        .foregroundColor(LiftPathTheme.primaryGreen)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                .disabled(!viewModel.isFormValid)
            }
            .onChange(of: viewModel.username) { _, _ in
                viewModel.validateForm()
            }
            .onChange(of: viewModel.age) { _, _ in
                viewModel.validateForm()
            }
        }
    }
}
