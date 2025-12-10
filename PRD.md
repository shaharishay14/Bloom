# PRODUCT REQUIREMENTS DOCUMENT (PRD)

| Metadata           | Details                  |
| :----------------- | :----------------------- |
| **Project**        | Bloom                    |
| **Version**        | 1.1 (Production Ready)   |
| **Status**         | Approved for Development |
| **Platform**       | iOS 17.0+                |
| **Device Support** | iPhone (Portrait Only)   |

---

## 1. EXECUTIVE SUMMARY

**Bloom** is a "Zen" utility app that visualizes physical activity as the growth of a digital plant.
**The Problem:** Activity rings and bar charts create anxiety and feel like "chores."
**The Solution:** An ambient, aesthetic interface where walking feels like nurturing a living thing.
**Core Loop:** Walk → Open App → Plant Grows → Midnight Reset.

---

## 2. DETAILED FEATURE SPECIFICATIONS

### 2.1 The Growth Engine (Core Logic)

The app tracks steps relative to a daily goal (Default: 10,000 steps).

- **Data Source:** HealthKit (`HKQuantityType.stepCount`).
- **Query Frequency:** On App Launch + Background Refresh (every ~1 hour).
- **The 7 Stages of Growth:**

  - **Stage 0 (0% - 9%):** `plant_00_seed` (A seed in soil).
  - **Stage 1 (10% - 24%):** `plant_01_sprout` (Tiny green shoot).
  - **Stage 2 (25% - 39%):** `plant_02_seedling` (Two leaves).
  - **Stage 3 (40% - 59%):** `plant_03_vegetative` (Stem grows taller).
  - **Stage 4 (60% - 79%):** `plant_04_bud` (Closed flower bud).
  - **Stage 5 (80% - 99%):** `plant_05_prebloom` (Petals visible).
  - **Stage 6 (100%+):** `plant_06_bloom` (Full flower + Particles).

- **The Midnight Reset:**

  - At 00:00 local time, the plant must reset to Stage 0.
  - _Edge Case:_ If the user crosses time zones, respect the _local device time_.

### 2.2 The User Interface (Dashboard)

- **Layout:**
  - **Top:** Minimalist Header ("Good Morning").
  - **Center:** The Plant View (60% screen height).
  - **Bottom:** Step Counter (e.g., "4,250 / 10,000") & Progress Bar.
- **Visual Effects:**
  - **Dynamic Background:**
    - 06:00 - 18:00: `DawnGradient` (Soft Blue -> White).
    - 18:00 - 06:00: `DuskGradient` (Deep Indigo -> Black).
  - **Transitions:**
    - State changes must use `.animation(.spring(response: 0.6, dampingFraction: 0.7))`.
    - **No hard cuts** between images. Use `.transition(.opacity)`.

### 2.3 Home Screen Widgets

- **Supported Families:** `systemSmall`, `systemMedium`.
- **Update Policy:** `.atEnd` (Refresh every time the timeline expires, approx 15-30 min).
- **UI Mirroring:** The widget must show the _exact same_ plant stage image as the main app.
- **Deep Link:** Tapping the widget opens the app directly.

---

## 3. TECHNICAL & DATA REQUIREMENTS

### 3.1 HealthKit Integration

- **Permission Flow:**
  - On first launch -> Show "Welcome" screen -> "Connect Health" button -> System Prompt.
- **Permission Denied Handling:**
  - If user denies access, show a specific "Wilted Plant" state (`plant_error`) with a button to open Settings.
- **Concurrency:**
  - All HealthKit queries must be performed on a background thread (`Task.detached`).
  - UI updates must happen on the `MainActor`.

### 3.2 Persistence

- **Technology:** `UserDefaults` (for MVP) or `SwiftData` (for V2).
- **Data Stored:**
  - `lastKnownStepCount` (Int) - For displaying data while HealthKit loads.
  - `currentStageIndex` (Int) - For the Widget to read quickly.
  - `dailyGoal` (Int) - Default 10,000.

---

## 4. DESIGN SYSTEM (ASSETS & TOKENS)

### 4.1 Typography

**Font Family:** SF Pro Rounded

- `Display Title`: Size 34, Weight: Bold.
- `Stat Text`: Size 20, Weight: Semibold.
- `Caption`: Size 14, Weight: Medium, Color: Secondary.

### 4.2 Color Palette

| Token Name     | Hex Code  | Usage                |
| :------------- | :-------- | :------------------- |
| `App.Soil`     | `#3E2723` | Ground/Pot elements  |
| `App.Stem`     | `#66BB6A` | Plant greenery       |
| `App.Petal`    | `#F06292` | Flower bloom         |
| `Bg.Day.Top`   | `#E3F2FD` | Day Gradient Start   |
| `Bg.Day.Bot`   | `#FFFFFF` | Day Gradient End     |
| `Bg.Night.Top` | `#1A237E` | Night Gradient Start |
| `Bg.Night.Bot` | `#000000` | Night Gradient End   |

### 4.3 Haptics

- **App Launch:** `soft` impact.
- **Growth Event:** `medium` impact.
- **Goal Reached:** `success` notification type.

---

## 5. NON-FUNCTIONAL REQUIREMENTS

- **Accessibility:** All images must have meaningful `accessibilityLabel` (e.g., "Plant is currently a small sprout").
- **Dark Mode:** The app uses custom gradients, but text must be legible in both Light and Dark system modes.
- **Localization:** English only for V1.
