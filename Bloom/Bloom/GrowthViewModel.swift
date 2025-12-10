//
//  GrowthViewModel.swift
//  Bloom
//
//  The Growth Engine: Business Logic & State Management
//  PRD Reference: Section 2.1 (Growth Engine), Section 3.1 (HealthKit)
//

import SwiftUI
import HealthKit

/// The brain of Bloom - manages step tracking and growth calculations
@MainActor
class GrowthViewModel: ObservableObject {
    // MARK: - Published State

    /// Current step count for today
    @Published var currentSteps: Int = 0

    /// Daily step goal
    @Published var dailyGoal: Int = 10_000

    /// Current plant growth stage
    @Published var plantStage: PlantStage = .seed

    /// HealthKit authorization status
    @Published var isAuthorized: Bool = false

    /// Loading state for UI feedback
    @Published var isLoading: Bool = false

    /// Error message (if any)
    @Published var errorMessage: String?

    // MARK: - Computed Properties

    /// Growth progress (0.0 - 1.0+)
    var progress: Double {
        // TODO: Calculate progress as currentSteps / dailyGoal
        // Guard against division by zero
        // Return a Double between 0.0 and 1.0+ (can exceed 1.0 if goal is surpassed)

        return 0.0
    }

    /// Progress as a percentage (0-100+)
    var progressPercentage: Int {
        // TODO: Convert progress to Int percentage
        // Example: 0.75 → 75

        return 0
    }

    // MARK: - HealthKit

    private let healthStore = HKHealthStore()

    /// The step count type we'll query
    private let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    // MARK: - Initialization

    init() {
        // TODO: Call loadPersistedData() to restore saved state

    }

    // MARK: - Public Methods

    /// Request HealthKit authorization
    func requestAuthorization() async {
        // TODO: Implement HealthKit authorization
        // Steps:
        // 1. Check if HKHealthStore.isHealthDataAvailable()
        //    - If false, set errorMessage and return
        // 2. Create a Set<HKObjectType> with stepType
        // 3. Call healthStore.requestAuthorization(toShare: [], read: typesToRead)
        // 4. If success: set isAuthorized = true, call fetchTodaySteps()
        // 5. If error: set isAuthorized = false, set errorMessage

    }

    /// Fetch today's step count from HealthKit
    func fetchTodaySteps() async {
        // TODO: Implement step fetching logic
        // Steps:
        // 1. Check if isAuthorized, if not call requestAuthorization()
        // 2. Set isLoading = true
        // 3. Get today's date range (midnight to now) using Calendar
        //    - Hint: Calendar.current.startOfDay(for: Date())
        // 4. Create HKQuery.predicateForSamples(withStart:end:)
        // 5. Create HKStatisticsQuery with:
        //    - quantityType: stepType
        //    - predicate: from step 4
        //    - options: .cumulativeSum
        // 6. In the completion handler:
        //    - Use Task { @MainActor in ... } to update UI
        //    - Get sum from result?.sumQuantity()
        //    - Convert to Int: sum.doubleValue(for: .count())
        //    - Update currentSteps
        //    - Update plantStage using PlantStage.from(progress:)
        //    - Call savePersistedData()
        //    - Set isLoading = false
        // 7. Execute the query: healthStore.execute(query)

    }

    /// Manually set step count (for testing/debugging)
    func setSteps(_ steps: Int) {
        // TODO: Implement manual step setting
        // 1. Set currentSteps = steps
        // 2. Update plantStage using PlantStage.from(progress:)
        // 3. Call savePersistedData()

    }

    /// Update daily goal
    func updateGoal(_ newGoal: Int) {
        // TODO: Implement goal update
        // 1. Set dailyGoal (ensure minimum 1000 steps using max())
        // 2. Recalculate plantStage
        // 3. Call savePersistedData()

    }

    // MARK: - Persistence (UserDefaults)

    private enum Keys {
        static let lastKnownStepCount = "bloom.lastKnownStepCount"
        static let currentStageIndex = "bloom.currentStageIndex"
        static let dailyGoal = "bloom.dailyGoal"
        static let lastUpdateDate = "bloom.lastUpdateDate"
    }

    /// Load persisted data from UserDefaults
    private func loadPersistedData() {
        // TODO: Implement persistence loading
        // Steps:
        // 1. Get UserDefaults.standard
        // 2. Check lastUpdateDate:
        //    - If date exists and is NOT today (use Calendar.current.isDateInToday())
        //    - Then reset: currentSteps = 0, plantStage = .seed, return early
        // 3. Load saved values:
        //    - currentSteps from Keys.lastKnownStepCount
        //    - dailyGoal from Keys.dailyGoal (default to 10_000 if 0)
        // 4. Recalculate plantStage from progress

    }

    /// Save current data to UserDefaults
    private func savePersistedData() {
        // TODO: Implement persistence saving
        // Steps:
        // 1. Get UserDefaults.standard
        // 2. Save these values:
        //    - currentSteps → Keys.lastKnownStepCount
        //    - dailyGoal → Keys.dailyGoal
        //    - plantStage.rawValue → Keys.currentStageIndex
        //    - Date() → Keys.lastUpdateDate

    }
}
