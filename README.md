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

## 🛠️ Step-by-Step Feature Creation Guide

This section outlines how to implement a new feature (e.g., **Goals**) in the codebase using our Clean Architecture and Offline-First guidelines.

### Step 1: Define the Domain Entity & Repository Contract
Define pure Dart files in the **Domain** layer (no third-party frameworks).

**1. Create Entity:** `lib/src/features/goals/domain/entities/goal.dart`
```dart
class Goal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final bool isSynced;
  final DateTime createdAt;

  const Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.isSynced,
    required this.createdAt,
  });
}
```

**2. Create Repository Contract:** `lib/src/features/goals/domain/repositories/goal_repository.dart`
```dart
import '../entities/goal.dart';

abstract interface class IGoalRepository {
  Future<List<Goal>> getGoals();
  Future<void> createGoal(Goal goal);
}
```

---

### Step 2: Implement the Data Layer (Model & Datasources)
Handle database serialization (`toMap` / `fromMap`) and database/API requests.

**1. Create Data Model:** `lib/src/features/goals/data/models/goal_model.dart`
```dart
import '../../domain/entities/goal.dart';

class GoalModel extends Goal {
  const GoalModel({
    required super.id,
    required super.title,
    required super.targetAmount,
    required super.currentAmount,
    required super.isSynced,
    required super.createdAt,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'] as String,
      title: map['title'] as String,
      targetAmount: (map['target_amount'] as num).toDouble(),
      currentAmount: (map['current_amount'] as num).toDouble(),
      isSynced: (map['is_synced'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

**2. Create Data Source Interface & Implementation:** `lib/src/features/goals/data/data_sources/goals_local_data_source.dart`
```dart
import '../../../../outer_layer/database/database_client.dart';
import '../models/goal_model.dart';

abstract interface class GoalsLocalDataSource {
  Future<List<GoalModel>> getGoals();
  Future<void> saveGoal(GoalModel goal);
}

class GoalsLocalDataSourceImpl implements GoalsLocalDataSource {
  final DatabaseClient _dbClient;
  GoalsLocalDataSourceImpl(this._dbClient);

  @override
  Future<List<GoalModel>> getGoals() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query('goals');
    return maps.map((map) => GoalModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveGoal(GoalModel goal) async {
    final db = await _dbClient.database;
    await db.insert('goals', goal.toMap());
  }
}
```

**3. Implement the Repository:** `lib/src/features/goals/data/repositories/goal_repository_impl.dart`
```dart
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../data_sources/goals_local_data_source.dart';
import '../models/goal_model.dart';

class GoalRepositoryImpl implements IGoalRepository {
  final GoalsLocalDataSource _localDataSource;

  GoalRepositoryImpl(this._localDataSource);

  @override
  Future<List<Goal>> getGoals() => _localDataSource.getGoals();

  @override
  Future<void> createGoal(Goal goal) async {
    final model = GoalModel(
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      currentAmount: goal.currentAmount,
      isSynced: goal.isSynced,
      createdAt: goal.createdAt,
    );
    await _localDataSource.saveGoal(model);
  }
}
```

---

### Step 3: Implement the Presentation Layer (BLoC)
Set up state management with `freezed` events and states.

**1. Define Event & State in one BLoC file:** `lib/src/features/goals/presentation/bloc/goals_bloc.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';

part 'goals_event.dart';
part 'goals_state.dart';
part 'goals_bloc.freezed.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final IGoalRepository _repository;

  GoalsBloc(this._repository) : super(const GoalsState.initial()) {
    on<GoalsFetched>((event, emit) async {
      emit(const GoalsState.loading());
      try {
        final goals = await _repository.getGoals();
        emit(GoalsState.success(goals));
      } catch (e) {
        emit(GoalsState.error(e.toString()));
      }
    });
  }
}
```

---

### Step 4: Register Dependencies and Routing

**1. Register in Dependency Injection Container:** `lib/src/system/di/injection.dart`
```dart
// Data source
sl.registerLazySingleton<GoalsLocalDataSource>(() => GoalsLocalDataSourceImpl(sl()));

// Repository
sl.registerLazySingleton<IGoalRepository>(() => GoalRepositoryImpl(sl()));

// BLoC (registered as factory)
sl.registerFactory(() => GoalsBloc(sl()));
```

**2. Add Screen Route in Router:** `lib/src/router/app_router.dart`
```dart
GoRoute(
  path: '/goals',
  builder: (context, state) => const GoalsView(),
)
```

---

### Step 5: Code Generation
Run `build_runner` to generate any missing `freezed` or serializable code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🔒 Security & Data
- **Soft Deletion**: Transactions are never physically deleted from the local database immediately; they are flagged with `is_deleted = 1` to ensure data integrity and future sync capabilities.
- **Local-First**: User data is stored securely in the local SQLite instance.


## 🤝 Contribution
This project is part of a specialized development workflow. Please ensure all architectural patterns (Clean Architecture) are followed when adding new features.

---
*Developed with a focus on Rich Aesthetics and Premium User Experience.*
