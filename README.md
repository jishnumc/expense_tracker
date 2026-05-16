# Expense Tracker

A modern, offline-first personal finance management application built with Flutter.

## 🚀 Overview

Expense Tracker helps users manage their daily finances with ease. It features a premium UI, real-time budget tracking, and offline-first persistence using SQLite.

### Key Features
- **Dashboard**: Real-time summary of income, expenses, and budget limits.
- **Transaction Management**: Add, view, and soft-delete transactions.
- **Budget Alerts**: Instant notifications when spending exceeds set limits.
- **Category Management**: Customizable transaction categories.
- **Offline First**: All data is persisted locally for uninterrupted usage.
- **Premium UI**: Modern dark mode design with glassmorphism, smooth animations, and skeleton loading states.

---

## 🏗 Architecture

The project follows **Clean Architecture** principles combined with the **BLoC (Business Logic Component)** pattern for state management. This ensures high testability, scalability, and separation of concerns.

### Project Structure
```text
lib/src/
├── app_ui/          # Design system (Themes, Colors, Components, Widgets)
├── features/        # Feature-driven modules (Auth, Home, Transaction, Profile)
│   ├── [feature]/
│   │   ├── data/          # Data sources, Models, Repository Impl
│   │   ├── domain/        # Entities, Repository Interfaces
│   │   └── presentation/  # BLoC, Views, Widgets
├── outer_layer/     # Infrastructure (Database, API Clients, Notifications)
├── router/          # App navigation (GoRouter)
├── system/          # Core system (Dependency Injection, Environment, Utils)
└── main.dart        # Entry point
```

### Tech Stack
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) with [freezed](https://pub.dev/packages/freezed) for union types.
- **Navigation**: [go_router](https://pub.dev/packages/go_router) for declarative routing.
- **Persistence**: [sqflite](https://pub.dev/packages/sqflite) for local SQLite storage.
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it).
- **Networking**: [chopper](https://pub.dev/packages/chopper) (ready for API integration).
- **Observability**: [talker](https://pub.dev/packages/talker_flutter) for advanced logging and debugging.
- **UI/UX**: [skeletonizer](https://pub.dev/packages/skeletonizer) for loading states, [flutter_svg](https://pub.dev/packages/flutter_svg) for iconography.

---

## 🛠 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run build runner to generate necessary code:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Run the application:
   ```bash
   flutter run
   ```

---

## 🔒 Security & Data
- **Soft Deletion**: Transactions are never physically deleted from the local database immediately; they are flagged with `is_deleted = 1` to ensure data integrity and future sync capabilities.
- **Local-First**: User data is stored securely in the local SQLite instance.

## 🤝 Contribution
This project is part of a specialized development workflow. Please ensure all architectural patterns (Clean Architecture) are followed when adding new features.

---
*Developed with a focus on Rich Aesthetics and Premium User Experience.*
