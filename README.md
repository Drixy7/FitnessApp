# Fitness Tracker & Weight Analytics

A high-performance mobile application engineered for advanced athletes, focusing on precise workout tracking and statistical bodyweight analysis. Built with **Flutter**, the app prioritizes absolute data accuracy, an offline-first architecture, and a clean Material 3 aesthetic.

## Core Capabilities

### 1. Intelligent Workout Engine
* **Lifecycle-Aware Timer:** A custom-engineered workout timer that safely survives background execution and device sleep states, ensuring your rest periods are tracked with millisecond accuracy.
* **Dynamic Sessions:** Highly flexible workout execution. Modify ongoing sessions on the fly, skip unavailable exercises, and add contextual workout notes.
* **Progressive Overload Tracking:** Instantly view historical performance (past sets, reps, and weights) directly within the active exercise view to ensure continuous progress.

### 2. Statistical Data Analysis
* **OLS Linear Regression:** Goes beyond simple moving averages. The app utilizes the *Ordinary Least Squares* method to calculate the true weekly weight trend, effectively filtering out noise caused by daily water retention and weight fluctuations.
* **Bulletproof Calendar Math:** All date and time calculations are strictly **DST-Safe** (Daylight Saving Time). This prevents critical week-segmentation bugs during timezone or seasonal time shifts.
* **Smart Segmentation:** Automatically aggregates and evaluates daily records into logical weekly blocks.

### 3. Technical Architecture
* **Offline-First (Isar NoSQL):** Powered by the lightning-fast local Isar database. Zero loading screens, zero network dependency, and complete user data sovereignty.
* **State Management:** Clean, scalable architecture separating the UI layer from business logic using the `Provider` package.
* **Smart Localization:** Enforces the European calendar standard (Monday as the first day of the week) via `en_GB` localization, while maintaining the global English UI.

## Tech Stack

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Database:** [Isar NoSQL](https://isar.dev/)
* **State Management:** [Provider](https://pub.dev/packages/provider)
* **Design System:** Material 3

## Getting Started

### Prerequisites
* Flutter SDK (latest stable version)
* Android Studio / VS Code (With dart/flutter extension)

### Installation

1. **Clone repository**

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```
3. **Generate Isar schemas (if required):**
    ```bash
    flutter pub run build_runner build
   ```
4. **Run the app:**
    ```bash
    flutter run
   ```
   