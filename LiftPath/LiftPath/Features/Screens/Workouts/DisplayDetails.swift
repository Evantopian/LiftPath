//
//  DisplayDetails.swift
//  LiftPath
//
//  Created by Evan Huang on 12/2/24.
//
import SwiftUI

struct DisplayDetails: View {
    let exercise: Exercise
    @State private var isAddedToSession: Bool = false
    @State private var isImageExpanded: Bool = false // State to manage image expansion
    @State private var imageHeight: CGFloat = 200 // Initial height of the image
    @Environment(\.presentationMode) var presentationMode // To manage the navigation stack
    
    var body: some View {
        VStack(spacing: 10) {  // Reduced spacing between elements
            // Chevron as the first item
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back to the previous view
                }) {
                    Image(systemName: "chevron.left") // Chevron symbol
                        .font(.title)
                        .foregroundColor(LiftPathTheme.primaryGreen)
                        .padding(.leading, 10) // Moved closer to the left
                }
                Spacer()
            }
            .padding(.top, 10) // Moved chevron slightly higher

            // Title
            Text(exercise.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal, 20)

            // Equipment as subtext (defaults to "None" if null)
            Text("Equipment: \(exercise.equipment.isEmpty ? "None" : exercise.equipment)")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 5)
                .padding(.horizontal, 20)

            // Exercise Image (GIF)
            GeometryReader { geometry in
                AsyncImage(url: URL(string: exercise.gifUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 40, height: isImageExpanded ? geometry.size.height : imageHeight)
                        .clipped() // Ensure image is cropped
                        .onTapGesture {
                            // Toggle image expansion on tap
                            withAnimation {
                                isImageExpanded.toggle()
                                imageHeight = isImageExpanded ? geometry.size.height : 200
                            }
                        }
                } placeholder: {
                    Color.gray
                        .frame(width: geometry.size.width - 40, height: isImageExpanded ? geometry.size.height : imageHeight)
                        .clipped() // Placeholder cropped similarly
                }
                .padding(.top, 10) // Moved the image higher
            }
            .frame(height: isImageExpanded ? nil : 200) // Dynamically adjust height based on expansion

            // Scrollable Info Card
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Display Exercise Target
                    HStack {
                        Text("Target:")
                            .font(.title2)
                            .fontWeight(.bold) // Bold the label
                            .foregroundColor(.black)
                        
                        Text(exercise.target)
                            .font(.title2) // Regular font for the value
                            .foregroundColor(.black)
                    }

                    // Display Secondary Muscles (Array)
                    if !exercise.secondaryMuscles.isEmpty {
                        HStack {
                            Text("Secondary Muscles:")
                                .font(.body)
                                .foregroundColor(.black)
                                .underline()
                            
                            Text(exercise.secondaryMuscles.joined(separator: ", "))
                                .font(.body) // Regular font for the value
                                .foregroundColor(.black)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Instructions:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        // Adding indentation to the first line of instructions
                        Text(exercise.instructions.joined(separator: " "))
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.top, 5)
                            .padding(.leading, 20) // Indent first line of instructions
                    }
                    Spacer()

                    Button(action: {
                        WorkoutSessionManager.shared.addExerciseToCurrentSession(exercise)
                        isAddedToSession = true
                    }) {
                        HStack {
                            Image(systemName: isAddedToSession ? "checkmark" : "plus")
                                .foregroundColor(isAddedToSession ? .green : .black)
                                .font(.title2) // Slightly smaller font for the icon
                            
                            Text(isAddedToSession ? "Added to Workout Session" : "Add to Workout Session")
                                .font(.subheadline) // Slightly smaller font for the text
                                .foregroundColor(isAddedToSession ? .green : .black)
                                .fixedSize(horizontal: false, vertical: true) // Allow the text to expand vertically if needed
                        }
                        .padding(.horizontal, 16) // Adjust horizontal padding to make the button slightly smaller
                        .padding(.vertical, 12)  // Adjust vertical padding to make the button slightly smaller
                        .background(Color.white) // White background for the button
                        .cornerRadius(25)
                        .shadow(radius: 5) // Optional: Add shadow for depth
                    }
                    .disabled(isAddedToSession) // Disable after adding to the session
                    Spacer()
                }
                .padding()
                .background(LiftPathTheme.primaryGreen) // Background color for the details section
                .cornerRadius(12)
                .shadow(radius: 10) // Optional: Add shadow for depth
                .overlay(
                    RoundedRectangle(cornerRadius: 12) // Border with rounded corners
                        .stroke(Color.white, lineWidth: 4) // White border
                )
            }
        }
        .background(Color.white) // Ensure this background color is set correctly
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
}
