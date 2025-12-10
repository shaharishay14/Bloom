//
//  DashboardView.swift
//  Bloom
//
//  Main Dashboard UI
//  PRD Reference: Section 2.2 (User Interface)
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = GrowthViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // TODO: Add background gradient
                // Use the backgroundGradient computed property below

                VStack(spacing: 0) {
                    // TODO: Add header
                    // Use the header computed property below
                    // Add .padding(.top, 60) and .padding(.horizontal, 24)

                    Spacer()

                    // TODO: Add PlantView
                    // Pass viewModel.plantStage to PlantView
                    // Set height to 60% of screen using geometry.size.height * 0.6

                    Spacer()

                    // TODO: Add stats footer
                    // Use the statsFooter computed property below
                    // Add .padding(.horizontal, 24) and .padding(.bottom, 40)
                }
            }
        }
        .task {
            // TODO: Fetch steps when view appears
            // Call: await viewModel.fetchTodaySteps()

        }
    }

    // MARK: - Components

    /// Dynamic gradient based on time of day
    private var backgroundGradient: LinearGradient {
        // TODO: Implement time-based gradient
        // Steps:
        // 1. Get current hour: Calendar.current.component(.hour, from: Date())
        // 2. Check if isDaytime: hour >= 6 && hour < 18
        // 3. Return LinearGradient with:
        //    - If daytime: Color.bloom.background.day.top → .day.bottom
        //    - If nighttime: Color.bloom.background.night.top → .night.bottom
        //    - startPoint: .top, endPoint: .bottom

        return LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
    }

    /// Minimalist header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                // TODO: Add greeting Text
                // Use the greeting computed property below
                // Font: .bloom.displayTitle
                // Color: .primary

                // TODO: Add loading indicator
                // If viewModel.isLoading, show "Loading..." text
                // Font: .bloom.caption
                // Color: .secondary
            }

            Spacer()
        }
    }

    /// Greeting based on time of day
    private var greeting: String {
        // TODO: Return time-based greeting
        // Get hour from Calendar.current.component(.hour, from: Date())
        // 0-12: "Good Morning"
        // 12-18: "Good Afternoon"
        // 18-24: "Good Evening"

        return "Good Morning"
    }

    /// Stats footer with step count and progress bar
    private var statsFooter: some View {
        VStack(spacing: 16) {
            // TODO: Step Counter HStack
            // Layout: "[4,250] / [10,000]     [42%]"
            // Use viewModel.currentSteps, viewModel.dailyGoal, viewModel.progressPercentage
            // Format numbers with .formatted()
            // Fonts: statText for numbers, caption for percentage

            // TODO: Progress Bar
            // Use ProgressView(value:) with min(viewModel.progress, 1.0)
            // Tint: Color.bloom.stem
            // Scale vertically: .scaleEffect(y: 2, anchor: .center)

            // TODO: Error Message (conditional)
            // If viewModel.errorMessage exists, show:
            // - HStack with warning icon and error text
            // - Button to open Settings
            // - Background: Color.orange.opacity(0.1)
            // - cornerRadius(8)
        }
    }
}

// MARK: - Preview

#Preview("Dashboard") {
    DashboardView()
}
