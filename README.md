# 🧩 VarosaMultiApp

**VarosaMultiApp** is a modular Flutter application built as part of a coding test to demonstrate advanced Flutter development skills across multiple domains including:

- State management using BLoC
- Local persistence with SQLite and SharedPreferences
- Dynamic UI rendering from JSON
- Clean architecture and modular design
- Native platform integration using MethodChannels
- Complex nested navigation patterns

This single app serves as a centralized hub for showcasing multiple independent tasks, each implemented with scalability, reusability, and cross-platform compatibility in mind.

---

## 📦 Features

### 1. 📝 To-Do App with Offline Support
- Add, edit, delete tasks
- Persist data using SQLite
- Schedule and handle local notifications

### 2. 📄 Dynamic Form Generator from JSON
- Multi-step form UI rendered from JSON
- Input validation and state persistence
- Resume partially filled form with confirmation dialog

### 3. 🛒 Mini E-Commerce Product List
- Infinite scroll product list
- Favorite feature with local persistence
- (Optional) Search and filtering

### 4. 🔌 Platform Integration via MethodChannel
- Native data fetch (battery, model, time, etc.)
- PlatformView integration for native buttons

### 5. 🧭 Nested Bottom Navigation
- Independent navigation stacks per tab
- Persistent bottom navigation UI
- Smooth transitions and intuitive UX

---

## ⚙️ Tech Stack

- **Flutter** (iOS & Android)
- **BLoC** for state management
- **SQLite**, **SharedPreferences**
- **MethodChannel**, **PlatformView**
- Modular & Clean Architecture

---


## Setup for .env files

Create a file named .env at the root directory of the project and paste the following content:

```
      # Application configuration
      # PRODUCTION
      BASE_URL=https://baseurl.com.np/
      PRIVACY_POLICY_URL=https://baseurl.com.np/privacy-policy
      HIVE_BOX_NAME=NaxaTemplateApp
      
      # STAGING
      BASE_URL_STAGING=https://baseurl-staging.com.np/
      PRIVACY_POLICY_URL_STAGING=https://baseurl-staging.com.np/privacy-policy
      HIVE_BOX_NAME_STAGING=NaxaTempleteAppStaging
      
      # DEV
      BASE_URL_DEV=https://baseurl-dev.com.np/
      PRIVACY_POLICY_URL_DEV=https://baseurl-dev.com.np/privacy-policy
      HIVE_BOX_NAME_DEV=NaxaTempleteAppDev
```

## How to run app with different flavors?

To run your Flutter app with different flavors, you can use the following methods:

#### Using `flutter run` with the `--flavor` flag:

```
      flutter run --flavor dev
               or
      flutter run --flavor staging
               or
      flutter run --flavor prod
```

#### Using Android Studio or IntelliJ

- Open your Flutter project in `Android Studio` or `IntelliJ`.
- Enter the desired `flavor` in the `Build Flavor` section in the "Run" configuration.
- Click the "Run" button to launch your app with the selected flavor.

## How to build release app with different flavors?

To build your Flutter release app with different flavors, you can use the following method:

#### Using `flutter build` with the `--flavor` flag:

```
      flutter build apk --release --flavor dev
      flutter build appbundle --release --flavor dev
               or
      flutter build apk --release --flavor staging
      flutter build appbundle --release --flavor staging
               or
      flutter build apk --release --flavor prod
      flutter build appbundle --release --flavor prod
```
