# Personal Expense Tracker

## Project Overview
A comprehensive Flutter application for tracking personal expenses, built using Clean Architecture principles.

## Features
- Add, edit, and delete expenses
- Categorize expenses
- View expense summaries
- Daily expense recording reminders

## Architecture
- Clean Architecture
- BLoC for State Management
- Hive for Local Storage
- Dependency Injection with get_it

## Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio / VS Code

## Setup Instructions
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build`
4. `flutter run`

## Testing
- Run unit tests: `flutter test`
- Run widget tests: `flutter test test/widget`

## Project Structure
- `lib/core/`: Core utilities and error handling
- `lib/data/`: Data sources, models, repositories
- `lib/domain/`: Business logic, entities, use cases
- `lib/presentation/`: UI, BLoC, widgets

## State Management
Uses Flutter BLoC for robust and predictable state management.

## Local Notifications
Implemented using `flutter_local_notifications` package.

## Contribution
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
