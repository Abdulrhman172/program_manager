# Contributing

1. Fork the repo and create a branch: `git checkout -b feature/my-change`
2. Copy `dart_defines.example.json` to `dart_defines.json` and add your own Supabase project values (never commit it).
3. Run `flutter pub get` then `flutter run --dart-define-from-file=dart_defines.json`.
4. Run `flutter analyze` and `flutter test` before opening a pull request.
5. Open a PR describing what changed and why.

Please never commit keys, passwords, or real student/staff data.
