#!/usr/bin/env bash
# Run from the repo root BEFORE making it public.
set -e

# 1) Remove files that should not be public
git rm -r --cached --ignore-unmatch android/build web_coordinator/public/__manus__ \
  swagger.json rename_project.ps1 generate_doc.dart fetch_schema.dart \
  test_acye.dart test_academy.dart test_db.dart test_groups.dart \
  test_join.dart test_supervisor.dart devtools_options.yaml || true
rm -rf android/build web_coordinator/public/__manus__ swagger.json \
  rename_project.ps1 generate_doc.dart fetch_schema.dart \
  test_acye.dart test_academy.dart test_db.dart test_groups.dart \
  test_join.dart test_supervisor.dart

# 2) Fix example author in package id (optional): com.example.program_manager

# 3) Commit
git add .gitignore .gitattributes LICENSE SECURITY.md CONTRIBUTING.md .env.example dart_defines.example.json
git commit -m "chore: prepare repository for open source"
echo "Done. Now scan history: see SECURITY_AUDIT.md (gitleaks / git filter-repo)."
