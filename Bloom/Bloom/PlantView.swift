//
//  PlantView.swift
//  Bloom
//
//  The Plant Display Component
//  PRD Reference: Section 2.2 (User Interface)
//

import SwiftUI

/// Represents the 7 stages of plant growth
enum PlantStage: Int, CaseIterable {
    case seed = 0        // 0% - 9%
    case sprout = 1      // 10% - 24%
    case seedling = 2    // 25% - 39%
    case vegetative = 3  // 40% - 59%
    case bud = 4         // 60% - 79%
    case prebloom = 5    // 80% - 99%
    case bloom = 6       // 100%+

    /// The corresponding asset name
    var imageName: String {
        switch self {
        case .seed: return "plant_00_seed"
        case .sprout: return "plant_01_sprout"
        case .seedling: return "plant_02_seedling"
        case .vegetative: return "plant_03_vegetative"
        case .bud: return "plant_04_bud"
        case .prebloom: return "plant_05_prebloom"
        case .bloom: return "plant_06_bloom"
        }
    }

    /// Accessibility label for VoiceOver
    var accessibilityLabel: String {
        switch self {
        case .seed: return "Plant is currently a seed in soil"
        case .sprout: return "Plant is a tiny green sprout"
        case .seedling: return "Plant is a small seedling with two leaves"
        case .vegetative: return "Plant has grown into a tall stem"
        case .bud: return "Plant has developed a closed flower bud"
        case .prebloom: return "Plant's flower petals are becoming visible"
        case .bloom: return "Plant is in full bloom with a beautiful flower"
        }
    }

    /// Calculate stage from progress percentage (0.0 - 1.0+)
    static func from(progress: Double) -> PlantStage {
        let percentage = progress * 100

        switch percentage {
        case 0..<10: return .seed
        case 10..<25: return .sprout
        case 25..<40: return .seedling
        case 40..<60: return .vegetative
        case 60..<80: return .bud
        case 80..<100: return .prebloom
        default: return .bloom
        }
    }
}

/// The main plant display component
struct PlantView: View {
    /// Current growth stage
    let stage: PlantStage

    /// Animation namespace for matchedGeometryEffect
    @Namespace private var plantAnimation

    var body: some View {
        GeometryReader { geometry in
            Image(stage.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityLabel(stage.accessibilityLabel)
                .transition(.opacity)
        }
    }
}

// MARK: - Preview

#Preview("Growth Stages") {
    VStack(spacing: 20) {
        ForEach(PlantStage.allCases, id: \.self) { stage in
            VStack {
                PlantView(stage: stage)
                    .frame(height: 150)

                Text("Stage \(stage.rawValue): \(stage.imageName)")
                    .font(.bloom.caption)
            }
        }
    }
    .padding()
}

#Preview("Interactive Demo") {
    // Preview with slider to test all stages
    struct DemoView: View {
        @State private var progress: Double = 0.0

        var body: some View {
            VStack(spacing: 30) {
                PlantView(stage: PlantStage.from(progress: progress))
                    .frame(height: 400)

                VStack {
                    Text("\(Int(progress * 100))% Complete")
                        .font(.bloom.statText)

                    Slider(value: $progress, in: 0...1.2)
                        .padding(.horizontal)
                }
            }
            .padding()
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progress)
        }
    }

    return DemoView()
}
