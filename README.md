# LiftPath
Last Updated: 11/08/2024

## Overview
LiftPath is an iOS app designed for fitness enthusiasts to manage their workouts and track progress. This project is part of my iOS development coursework at Hunter College.

## Directory Structure
LiftPath/
├── App/
│   └── LiftPathApp.swift
│
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift         // Main dashboard view
│   │   └── HomeViewModel.swift    // Manages home view state & logic
│   │
│   ├── Workouts/
│   │   ├── WorkoutListView.swift  // List of workouts/exercises
│   │   └── WorkoutViewModel.swift // Handles workout data & API calls
│   │
│   └── Profile/
│       ├── ProfileView.swift      // User profile & stats
│       └── ProfileViewModel.swift // Manages profile data
│
├── Models/
│   ├── Exercise.swift    // Exercise data model
│   ├── Workout.swift     // Workout data model
│   └── Profile.swift     // User profile model
│
├── Services/
│   └── ExerciseService.swift  // API integrationw
│
└── Components/
    └── ProgressBar.swift      // Reusable progress bar component
    └── Heatmap.swift          // User activity tracking component

# Tech Stack:
Project Guidelines (TBA When Finished.)