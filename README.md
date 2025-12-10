# Bloom 🌿

![Platform](https://img.shields.io/badge/Platform-iOS%2017.0+-black)
![Language](https://img.shields.io/badge/Language-Swift%206-orange)
![UI](https://img.shields.io/badge/UI-SwiftUI-blue)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-purple)

> **Walk to grow.**
> Bloom is an aesthetic, gamified step tracker that visualizes physical activity as the growth of a digital plant.

---

## 📱 App Overview

Bloom transforms the mundane task of tracking steps into a calming, mindful experience. Instead of graphs and charts, users nurture a procedural plant that grows from a seed to a full bloom based on their daily activity.

The app leverages **HealthKit** for privacy-focused data access and uses a custom state-machine to handle visual transitions, ensuring the experience feels organic and rewarding.

---

## ✨ Key Features

* **🌱 Procedural Growth Engine:** A 7-stage visual system that maps step counts (0 - 10k) to plant maturity levels.
* **🔄 Daily Cycle:** The plant resets at midnight, creating a daily "game loop" that encourages consistent activity.
* **🏠 Home Screen Widgets:** Interactive widgets (Small & Medium) that mirror the plant's status, keeping motivation visible at a glance.
* **🔒 Privacy First:** Built on Apple's HealthKit. Data never leaves the device.
* **🎨 Organic Design:** A "Glassmorphism" UI with dynamic sky gradients that shift from Dawn to Dusk.

---

## 🛠 Tech Stack & Architecture

This project strictly adheres to **Clean Architecture** principles to ensure scalability and maintainability.

* **Language:** Swift 6
* **Framework:** SwiftUI
* **Data:** HealthKit, SwiftData (Persistence)
* **Extensions:** WidgetKit
* **Architecture:** **MVVM** (Model-View-ViewModel)

### Folder Structure
The project follows a feature-based organization strategy:
```text
Bloom/
├── App/                # Entry point & Configuration
├── Features/           # Core User Flows
│   ├── Dashboard/      # Main Plant View (Views + ViewModels)
│   └── Onboarding/     # Permissions Flow
├── Core/               # Shared logic
│   ├── Health/         # HealthKit Managers
│   ├── DesignSystem/   # Color Palettes, Typography, Components
│   └── Extensions/     # Swift Helpers
└── Resources/          # Assets.xcassets (Image Sequences)
