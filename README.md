
# Walmart Coding Challenge – iOS App

This is an iOS application which embraces modern iOS development practices and leverages a clean architecture to ensure a scalable, maintainable, and testable codebase.

---

##  Project Structure

The project follows a modular structure inspired by Clean Architecture principles:

- **Views** – SwiftUI components and screen layouts
- **ViewModel** – Business logic and data transformation for UI
- **NetworkManager** – Handles all API interactions and networking logic
- **Repository** – Abstraction layer between data sources and ViewModels
- **Model** – Swift data models for parsing and managing data
- **Tests** – Includes Unit and UI tests to ensure functionality

---

## Architecture

The app is built using the **MVVM (Model-View-ViewModel)** architecture pattern:

- Clear separation of concerns
- Improved testability and modularity
- Seamless data binding between View and ViewModel using `@Published` properties

---

## Features

-  SwiftUI-based modern user interface
-  Clean and scalable MVVM architecture
-  Asynchronous network layer with Combine
-  Modular Repository pattern
-  Includes Unit Tests and UI Tests for validation

---

## 📸 Screenshots

| Country Detail List | Search Country |
|-------------|----------------|
| ![Home](Screenshots/home.png) | ![Detail](Screenshots/detail.png) |

> These images show the main flow of the app, including the country list and search view.

---


##  Requirements

- iOS 14.0 or later
- Xcode 12.0 or later
- Swift 5.0+

---

##  Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/WalmartCodingChallenge.git
   ```

2. Open the project in Xcode:
   ```
   WalmartCodingChallenge.xcodeproj
   ```

3. Build and run the project using:
   ```
   Cmd + R
   ```

---

##  Running Tests

This project includes both **Unit Tests** and **UI Tests**.

To run all tests:
```bash
Cmd + U
```

Alternatively, use Xcode’s **Test Navigator** to run specific test cases.

- **Unit Tests**: `WalmartCodingChallengeTests`
- **UI Tests**: `WalmartCodingChallengeUITests`

---
