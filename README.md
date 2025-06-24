# LiftPath

*Last Updated: 11/08/2024*

## Overview

LiftPath is an iOS app designed for fitness enthusiasts to manage their workouts and track progress. This project is part of my iOS development coursework at Hunter College.

## Directory Structure

```
LiftPath/
├── App/
│   └── LiftPathApp.swift          // Main app entry point
│
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift         // Main dashboard view
│   │   └── HomeViewModel.swift    // Manages home view state and logic
│   │
│   ├── Workouts/
│   │   ├── WorkoutListView.swift  // Lists available workouts and exercises
│   │   └── WorkoutViewModel.swift // Handles workout data and API calls
│   │
│   └── Profile/
│       ├── ProfileView.swift      // Displays user profile and stats
│       └── ProfileViewModel.swift // Manages user profile data
│
├── Models/
│   ├── Exercise.swift             // Exercise data model
│   ├── Workout.swift              // Workout data model
│   └── Profile.swift              // User profile data model
│
├── Services/
│   └── ExerciseService.swift      // API integration for exercises
│
└── Components/
    ├── ProgressBar.swift          // Reusable progress bar component
    └── Heatmap.swift              // User activity tracking component
```

## Tech Stack
- Swift
