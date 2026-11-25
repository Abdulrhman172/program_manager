# Program Manager

A cross-platform, Arabic-first (RTL) app for managing **graduation research projects** at the College of Business Administration, University of Science and Technology, Aden, Yemen.

It gives the program manager one place to follow students, supervisors, research groups, the five research stages, submission approvals, and grades, replacing scattered files and manual paperwork.

> **Status: early-stage / actively developed.** The core program-manager workflow works against a Supabase backend. Some modules are still in progress (see [Roadmap](#roadmap)).

## The problem

Graduation research in many universities in Yemen and the wider Arabic-speaking region is still tracked through paper forms, messaging apps, and spreadsheets. Supervisors, students, and the program manager each hold part of the picture, and nobody sees the whole. Affordable, Arabic-native tools for this workflow are rare.

Program Manager aims to be a simple, open-source tool that any faculty can adopt and adapt.

## Features

| Module | What it does |
|---|---|
| **Authentication** | Program-manager login backed by Supabase |
| **Dashboard** | Overview statistics and navigation hub |
| **Students** | Add, edit, search, and delete student records |
| **Supervisors** | View supervisors and toggle their active status |
| **Research stages** | Manage the five research phases and their status and dates |
| **Approval** | Review and approve or reject phase-1 submissions |
| **Teams** | Manage student research groups |
| **Grades monitoring** | Record grades per group: supervisor (60) and program manager (40), total out of 100. See [`doc/grades_monitoring_interface.md`](doc/grades_monitoring_interface.md) |
| **Settings** | Profile and preferences |
| **Research archive** | Browse and archive completed research *(in progress)* |

The UI is responsive: a fixed sidebar on wide screens and a drawer on mobile.

## Tech stack

- **Flutter / Dart** (Material 3, Arabic RTL, `ar_SA` locale)
- **Supabase** (PostgreSQL + Auth) as the backend
- **Provider** (`ChangeNotifier` controllers) for state management
- `responsive_builder`, `shared_preferences`, `file_picker`, `awesome_dialog`, and others (see [`pubspec.yaml`](pubspec.yaml))
- Targets: Android, iOS, Web, Windows
- `web_coordinator/`: an experimental React + TypeScript dashboard prototype

## Project structure

```
lib/
├── main.dart
├── core/                 # Supabase service, theme, layout, shared widgets
└── features/
    └── <feature>/
        ├── controller/   # ChangeNotifier: business logic + Supabase calls
        ├── model/        # Data classes (toJson / fromJson)
        └── view/         # UI
doc/                      # Developer documentation
web_coordinator/          # React dashboard prototype
```

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.11.1`)
- A [Supabase](https://supabase.com) project

### Run

```bash
git clone https://github.com/Abdulrhman172/program_manager.git
cd program_manager
flutter pub get
flutter run
```

### Using your own Supabase project

The Supabase URL and public (anon) key are currently set in [`lib/main.dart`](lib/main.dart). Replace them with your own project's values before deploying your own instance. The database tables are documented in the data dictionary (`قاموس_البيانات.doc`) and [`doc/grades_monitoring_interface.md`](doc/grades_monitoring_interface.md).

**Before going live:** enable Row Level Security on every table and never put a `service_role` key in the app. See [SECURITY.md](SECURITY.md).

## Roadmap

- [ ] Move Supabase configuration to `--dart-define-from-file` (see `dart_defines.example.json`)
- [ ] Publish a SQL schema so a new instance can be created in one step
- [ ] Switch login to Supabase Auth with hashed credentials
- [ ] Connect the research archive to live data
- [ ] Notifications
- [ ] Supervisor and student roles, not only the program manager
- [ ] Automated tests and CI
- [ ] English UI option and localization
- [ ] Screenshots and a short demo

## Contributing

Contributions are welcome, especially from people working on academic workflows in Arabic. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first, and never commit keys, passwords, or real student or staff data.

To report a security issue, follow [SECURITY.md](SECURITY.md).

## License

Released under the [MIT License](LICENSE).
