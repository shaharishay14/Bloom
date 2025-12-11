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
                backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    header.padding(.top, 60).padding(.horizontal, 85) // Centered layout for Zen aesthetic

                    Spacer()

                    PlantView(stage: viewModel.plantStage)
                        .frame(height: geometry.size.height * 0.6)
                    
                    Spacer()

                    statsFooter
                        .padding(.bottom, 40).padding(.horizontal, 85) // Centered layout for Zen aesthetic
                }
            }
        }
        .task {
            await viewModel.fetchTodaySteps()

        }
    }

    // MARK: - Components

    /// Dynamic gradient based on time of day
    private var backgroundGradient: LinearGradient {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDayTime = hour >= 6 && hour < 18
        
        if isDayTime {
            return LinearGradient(colors:[Color.bloom.background.day.top, Color.bloom.background.day.bottom],
              startPoint: .top,
              endPoint: .bottom)
        }
        else {
            return LinearGradient(colors:[Color.bloom.background.night.top, Color.bloom.background.night.bottom],
              startPoint: .top,
              endPoint: .bottom)
        }
    }

    /// Minimalist header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.bloom.displayTitle)
                    .foregroundColor(.primary)
                
                if viewModel.isLoading {
                    Text("Loading...")
                        .font(.bloom.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
    }

    /// Greeting based on time of day
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12..<18:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }

    /// Stats footer with step count and progress bar
    private var statsFooter: some View {
        VStack(spacing: 16) {
            HStack {
                Text("\(viewModel.currentSteps.formatted()) / \(viewModel.dailyGoal.formatted())")
                    .font(.bloom.statText)
                
                Spacer()
                
                Text("\(viewModel.progressPercentage)%")
                    .font(.bloom.caption)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: min(viewModel.progress, 1.0))
                .tint(Color.bloom.stem)
                .scaleEffect(y: 2, anchor: .center)
                .clipShape(Capsule())

            if let message = viewModel.errorMessage {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    
                    Text(message)
                        .font(.caption)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    Button("Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .font(.caption.bold())
                }
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview("Dashboard") {
    DashboardView()
}
