//
//  Theme.swift
//  Bloom
//
//  Design System: Color Palette & Typography Tokens
//  PRD Reference: Section 4 (Design System)
//

import SwiftUI

// MARK: - Color Palette

extension Color {
    /// The Bloom color palette
    struct Bloom {
        // Plant Colors
        let soil: Color
        let stem: Color
        let petal: Color

        // Background Gradients
        struct Background {
            struct Day {
                let top: Color
                let bottom: Color
            }

            struct Night {
                let top: Color
                let bottom: Color
            }

            let day: Day
            let night: Night
        }

        let background: Background
    }

    /// Access point for the Bloom palette
    static let bloom = Bloom(
        // TODO: Implement color tokens from PRD Section 4.2
        // Example: soil: Color(hex: "3E2723")
        soil: Color(hex: "3E2723"),
        stem: Color(hex: "66BB6A"),
        petal: Color(hex: "F06292"),

        background: Bloom.Background(
            day: Bloom.Background.Day(
                top: Color(hex: "E3F2FD"),
                bottom: Color(hex: "FFFFFF")
            ),
            night: Bloom.Background.Night(
                top: Color(hex: "1A237E"), 
                bottom: Color(hex: "000000")
            )
        )
    )
}

// MARK: - Hex Color Initializer

extension Color {
    /// Initialize Color from hex string
    /// - Parameter hex: Hex string (e.g., "3E2723" or "#3E2723")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

// MARK: - Typography

extension Font {
    /// The Bloom typography scale (SF Pro Rounded)
    struct Bloom {
        // TODO: Implement typography tokens from PRD Section 4.1
        // PRD Spec: Display Title (34pt, Bold)
        static let displayTitle: Font = .system(size: 34, weight: .bold, design: .rounded)

        // PRD Spec: Stat Text (20pt, Semibold)
        static let statText: Font = .system(size: 20, weight: .semibold, design: .rounded)

        // PRD Spec: Caption (14pt, Medium)
        static let caption: Font = .system(size: 14, weight: .medium, design: .rounded)
    }

    /// Access point for Bloom typography
    static let bloom = Bloom.self
}

// MARK: - Preview Helper

#Preview("Color Palette") {
    VStack(spacing: 20) {
        // Plant Colors
        HStack(spacing: 12) {
            Circle()
                .fill(Color.bloom.soil)
                .frame(width: 60, height: 60)
                .overlay(Text("Soil").font(.caption).foregroundColor(.white))

            Circle()
                .fill(Color.bloom.stem)
                .frame(width: 60, height: 60)
                .overlay(Text("Stem").font(.caption).foregroundColor(.white))

            Circle()
                .fill(Color.bloom.petal)
                .frame(width: 60, height: 60)
                .overlay(Text("Petal").font(.caption).foregroundColor(.white))
        }

        // Typography
        VStack(alignment: .leading, spacing: 12) {
            Text("Display Title")
                .font(.bloom.displayTitle)

            Text("Stat Text")
                .font(.bloom.statText)

            Text("Caption Text")
                .font(.bloom.caption)
        }
    }
    .padding()
}
