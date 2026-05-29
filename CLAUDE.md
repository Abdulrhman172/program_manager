# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Format code
flutter format lib/

# Clean and rebuild
flutter clean && flutter pub get

# Build for release
flutter build apk --release
flutter build web
```

## Architecture

**Head of Department** is a Flutter app for graduate research program coordination, built in Arabic (RTL, `Locale('ar', 'SA')` hardcoded) with Supabase as the backend.

### Entry Point & State Management

[lib/main.dart](lib/main.dart) initializes Supabase, wraps the app in `MultiProvider`, and routes authenticated users to `MainLayout`.

State management uses **Provider + ChangeNotifier** (no Bloc/Riverpod). Each feature has a dedicated controller that:
1. Fetches from Supabase on construction
2. Caches in a private list
3. Applies search/filter to a derived list
4. Calls `notifyListeners()` to trigger rebuilds
5. Uses optimistic UI updates with rollback on error

### Routing

Routing is **manual switch/case** inside [lib/core/widgets/main_layout.dart](lib/core/widgets/main_layout.dart) — no GoRouter or Navigator 2.0. The `DashboardController` tracks the current route via `_currentRoute`. Routes: `/`, `/students`, `/supervisors`, `/stages`, `/approval`, `/research`, `/teams`, `/grades`, `/settings`.

### Directory Structure

```
lib/
├── core/
│   ├── services/       # SupabaseService singleton
│   ├── theme/          # AppTheme, AppColors (Material 3, blue primary)
│   └── widgets/        # MainLayout (responsive scaffold), AppDrawer
└── features/           # One folder per feature
    └── [feature]/
        ├── controller/ # ChangeNotifier, business logic + Supabase calls
        ├── model/      # Data classes with toJson/fromJson
        └── view/       # UI widgets
```

### Features

| Feature | Description |
|---------|-------------|
| `auth` | Program manager login via Supabase `ProgramManager` table |
| `dashboard` | Stats overview, navigation hub |
| `students` | Student CRUD |
| `supervisors` | Toggle supervisor active status |
| `stages` | Manage 5 research phases |
| `approval` | Approve/reject phase 1 submissions |
| `research` | Browse/archive research (currently uses hardcoded mock data, not live DB) |
| `teams` | Student group management via `student_group_view` |
| `grades` | Record student grades |
| `notifications` | System notifications |
| `settings` | Profile and preferences |

### Responsive Layout

`MainLayout` switches between a fixed sidebar (desktop, width > 800px) and a hamburger drawer (mobile) using the `responsive_builder` package.

### Key Dependencies

- **supabase_flutter** — primary backend (PostgreSQL + Auth); credentials are hardcoded in `main.dart`
- **provider** — state management
- **shared_preferences** — session/auth token persistence
- **firebase_messaging + flutter_local_notifications** — push notifications
- **awesome_dialog** — confirmation dialogs throughout the app
- **get_it** — service locator (minimal use)
- **dartz** — Either/Option types (minimal use)
- **get** — present in pubspec but not actively used

### Notes

- The `research` feature's controller uses hardcoded mock data, not live Supabase queries yet.
- `test_db.dart` at project root is unused scaffolding.
- `google_sign_in` is configured but not wired into any active auth flow.
