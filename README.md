# 🧩 VarosaMultiApp

**VarosaMultiApp** is a modular Flutter application built to demonstrate advanced Flutter development skills across multiple domains. This project showcases a clean, scalable architecture that implements various features commonly required in modern mobile applications.

![Flutter Version](https://img.shields.io/badge/Flutter-3.8+-blue.svg)
![Dart Version](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📱 Overview

VarosaMultiApp serves as a centralized hub for showcasing multiple independent features, each implemented with scalability, reusability, and cross-platform compatibility in mind. The application follows clean architecture principles and uses BLoC for state management.

## 📦 Features

### 1. 📝 To-Do App with Offline Support
- Add, edit, delete tasks
- Persist data using SQLite
- Schedule and handle local notifications
- Due date reminders

### 2. 📄 Dynamic Form Generator from JSON
- Multi-step form UI rendered from JSON
- Input validation and state persistence
- Resume partially filled form with confirmation dialog

### 3. 🛒 Mini E-Commerce Product List
- Infinite scroll product list
- Favorite feature with local persistence
- Product filtering and search capabilities

### 4. 🔌 Platform Integration via MethodChannel
- Native data fetch (battery, model, time, etc.)
- PlatformView integration for native buttons
- Demonstrates cross-platform capabilities

### 5. 🧭 Nested Bottom Navigation
- Independent navigation stacks per tab
- Persistent bottom navigation UI
- Smooth transitions and intuitive UX

## 🏗️ Architecture

The project follows a modular architecture with clean separation of concerns:

```
lib/
├── core/            # Core functionality and services
├── database/        # Database configuration and providers
├── l10n/            # Localization resources
├── modules/         # Feature modules
│   ├── common/      # Shared features (auth, onboarding, etc.)
│   ├── form_generator/
│   ├── method_channel/
│   ├── mini_ecommerce/
│   ├── nested_nav/
│   └── todo_app/
└── utils/           # Utility functions and extensions
```

Each module follows a similar structure:
- **features/** - Contains individual features within the module
  - **bloc/** - BLoC state management
  - **models/** - Data models
  - **repositories/** - Data access layer
  - **services/** - Business logic
  - **views/** - UI components

## ⚙️ Tech Stack

- **Flutter** (iOS & Android)
- **BLoC** for state management
- **SQLite** & **Hive** for local storage
- **Firebase** for messaging and notifications
- **Go Router** for navigation
- **Dio** for network requests
- **Method Channel** for native platform integration
- **Internationalization** support

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/itheamc/varosa-multi-app.git
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file at the root directory with the following content:
   ```
    # Application configuration
    # PRODUCTION
    BASE_URL=https://dummyjson.com/
    PRIVACY_POLICY_URL=https://varosaapp.com.np/privacy-policy
    HIVE_BOX_NAME=VarosaMultiApp
    # STAGING
    BASE_URL_STAGING=https://dummyjson.com/
    PRIVACY_POLICY_URL_STAGING=https://varosaapp-staging.com.np/privacy-policy
    HIVE_BOX_NAME_STAGING=VarosaMultiAppStaging
    # DEV
    BASE_URL_DEV=https://dummyjson.com/
    PRIVACY_POLICY_URL_DEV=https://varosaapp-dev.com.np/privacy-policy
    HIVE_BOX_NAME_DEV=VarosaMultiAppDev
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## 🔄 Running with Different Flavors

### Using `flutter run` with the `--flavor` flag:

```bash
flutter run --flavor dev
# or
flutter run --flavor staging
# or
flutter run --flavor prod
```

### Using Android Studio or IntelliJ

1. Open your Flutter project in `Android Studio` or `IntelliJ`
2. Enter the desired `flavor` in the `Build Flavor` section in the "Run" configuration
3. Click the "Run" button to launch your app with the selected flavor

## 📦 Building Release App with Different Flavors

### Using `flutter build` with the `--flavor` flag:

```bash
# For Android
flutter build apk --release --flavor dev
flutter build appbundle --release --flavor dev
# or
flutter build apk --release --flavor staging
flutter build appbundle --release --flavor staging
# or
flutter build apk --release --flavor prod
flutter build appbundle --release --flavor prod

# For iOS
flutter build ios --release --flavor dev
# or
flutter build ios --release --flavor staging
# or
flutter build ios --release --flavor prod
```

Built with ❤️ using Flutter