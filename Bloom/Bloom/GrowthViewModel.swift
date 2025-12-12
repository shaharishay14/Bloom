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
        guard dailyGoal > 0 else { return 0.0 }
        
        return Double(currentSteps) / Double(dailyGoal)
    }

    /// Progress as a percentage (0-100+)
    var progressPercentage: Int {
        return Int(progress * 100)
    }

    // MARK: - HealthKit

    private let healthStore = HKHealthStore()

    /// The step count type we'll query
    private let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    // MARK: - Initialization

    init() {
        loadPersistedData()

    }

    // MARK: - Public Methods

    /// Request HealthKit authorization
    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "HealthKit is not available on this device."
            return
        }
        
        let typesToRead: Set<HKObjectType> = [stepType]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
            isAuthorized = true
            errorMessage = nil
            
            await fetchTodaySteps()
        }
        catch {
            isAuthorized = false
            errorMessage = "Please enable Health access in Settings."
        }
            
    }

    /// Fetch today's step count from HealthKit
    func fetchTodaySteps() async {
        guard isAuthorized else {
            await requestAuthorization()
            return
        }
        
        isLoading = true
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { [weak self] _, result, error in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Failed to fetch steps: \(error.localizedDescription)"
                    return
                }
                
                if let sum = result?.sumQuantity() {
                    let steps = Int(sum.doubleValue(for: .count()))
                    self.currentSteps = steps
                    self.plantStage = PlantStage.from(progress: self.progress)
                    self.savePersistedData()
                }
                else {
                    self.currentSteps = 0
                    self.plantStage = .seed
                }
                
                self.errorMessage = nil
            }
        }
        healthStore.execute(query)
    }
    

    /// Manually set step count (for testing/debugging)
    func setSteps(_ steps: Int) {
        currentSteps = steps
        plantStage = PlantStage.from(progress: progress)
        savePersistedData()

    }

    /// Update daily goal
    func updateGoal(_ newGoal: Int) {
        dailyGoal = max(1_000, newGoal)
        plantStage = PlantStage.from(progress: progress)
        savePersistedData()

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
        let defaults = UserDefaults.standard
        
        if let lastDate = defaults.object(forKey: Keys.lastUpdateDate) as? Date {
            if !Calendar.current.isDateInToday(lastDate) {
                print("New day detected: Resetting steps.")
                
                currentSteps = 0
                plantStage = .seed
                
                let saveGoal = defaults.integer(forKey: Keys.dailyGoal)
                dailyGoal = saveGoal > 0 ? saveGoal : 10_000
                
                return
            }
        }
        
        currentSteps = defaults.integer(forKey: Keys.lastKnownStepCount)
        
        let saveGoal = defaults.integer(forKey: Keys.dailyGoal)
        dailyGoal = saveGoal > 0 ? saveGoal : 10_000
        
        plantStage = PlantStage.from(progress: progress)
        

    }

    /// Save current data to UserDefaults
    private func savePersistedData() {
        let defaults = UserDefaults.standard
        
        defaults.set(currentSteps, forKey: Keys.lastKnownStepCount)
        defaults.set(dailyGoal, forKey: Keys.dailyGoal)
        defaults.set(plantStage.rawValue, forKey: Keys.currentStageIndex)
        defaults.set(Date(), forKey: Keys.lastUpdateDate)
    }
}
