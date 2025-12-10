# PRODUCT REQUIREMENTS DOCUMENT (PRD)

**Project:** Bloom
**Version:** 1.0

---

## 1. CORE CONCEPT

**Bloom** is an aesthetic step-tracking app.
**The Hook:** The user walks to keep their digital garden alive. The plant resets every morning, creating a daily loop of nurturing.

---

## 2. FEATURE SPECIFICATIONS

### 2.1 The "Growth Engine" (Logic)

The core mechanic is mapping **Steps** to **Visual Stages**.

- **Input:** Daily Step Count (from HealthKit).
- **Reset:** Auto-reset to Stage 0 at 00:00 (Midnight).
- **Stages:**
  - **Stage 0 (0 - 999):** Dormant Seed / Soil.
  - **Stage 1 (1,000 - 2,499):** Sprout (Green shoot).
  - **Stage 2 (2,500 - 3,999):** Seedling (First leaves).
  - **Stage 3 (4,000 - 5,999):** Growth (Stem elongates).
  - **Stage 4 (6,000 - 7,999):** Budding (Closed flower bud).
  - **Stage 5 (8,000 - 9,999):** Pre-Bloom (Petal color visible).
  - **Stage 6 (10,000+):** Full Bloom (Glowing effect).

### 2.2 The Main Dashboard (UI)

- **Centerpiece:** The Plant View (taking up 60% of vertical space).
- **Background:** A subtle gradient that simulates the sky (Dawn to Dusk).
- **Data Display:** Minimalist. Do not show graphs. Show only current step count and a motivational phrase (e.g., "Keep growing").
- **Animation:** Transitions between stages must be smooth (using `matchedGeometryEffect` or standard transitions), never instant.

### 2.3 The Widget

- **Function:** A mirror of the main app.
- **State:** Must update periodically to show the current growth stage on the Home Screen.
- **Fallback:** If permission is denied, show a "Sleeping Seed" icon.

---

## 3. DESIGN SYSTEM GUIDELINES

### 3.1 Colors ("Organic Modern")

- **Soil:** `#3E2723`
- **Stem/Leaf:** `#81C784`
- **Petals:** `#F48FB1` (Pink) or `#FFF59D` (Yellow) - _User customizable in V2._
- **Sky Gradient:** `#E3F2FD` (Light Blue) to `#E8EAF6` (Soft Indigo).

### 3.2 Typography

- **Font Family:** SF Pro Rounded.
- **Weight:** Medium to Bold for headers; Regular for stats.

---

## 4. TECHNICAL CONSTRAINTS

- **Device Support:** iOS 17+.
- **HealthKit:** Read-only access (Steps).
- **Orientation:** Portrait only.
