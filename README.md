# PeriodicQuest

Production-ready baseline for a Flutter application repository with clean contribution standards, issue/PR workflows, and CI checks.

## Project Overview

This repository is structured for team collaboration and long-term maintainability, including:
- standardized issue and pull request templates
- contribution and review guidelines
- CI checks for formatting, analysis, and tests

Implementation-specific product details should be filled in as the app scope is finalized.

## Flutter Setup Instructions

1. Install Flutter SDK from the official docs: [Flutter Install Guide](https://docs.flutter.dev/get-started/install)
2. Verify setup:
   ```bash
   flutter doctor
   ```
3. Resolve any reported platform/toolchain issues before proceeding.

## Install Dependencies

From repository root:

```bash
flutter pub get
```

## Run the App

1. List available devices:
   ```bash
   flutter devices
   ```
2. Run app:
   ```bash
   flutter run
   ```

## Run Tests

Run unit/widget tests:

```bash
flutter test
```

Run static checks:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
```

## Folder Structure

Current repository baseline:

```text
.
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   ├── CODEOWNERS
│   └── PULL_REQUEST_TEMPLATE.md
├── CONTRIBUTING.md
├── README.md
└── .gitignore
```

When app files are present, expected Flutter structure commonly includes:
- `lib/` for app source code
- `test/` for test suites
- `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/` for platform targets

## Branch Strategy

- `main`: protected branch for stable, releasable code
- working branches:
  - `feature/<name>`
  - `fix/<name>`
  - `chore/<name>`

## Pull Request Workflow

1. Create or pick an issue first.
2. Create a branch from `main`.
3. Implement and validate changes locally (`format`, `analyze`, `test`).
4. Open a PR using the template and link the issue (`Closes #<number>`).
5. Merge after CI passes and required reviews are complete.

## Release / Deployment Overview

Release and store deployment process is not yet documented.

Placeholder plan:
- define versioning and release cadence
- document build/signing process per platform
- add release workflow automation when pipeline requirements are finalized