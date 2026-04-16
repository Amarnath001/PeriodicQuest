# Contributing to PeriodicQuest

Thanks for contributing. This project follows an issue-first, review-driven workflow for safe and maintainable Flutter/Dart development.

## Branch Naming Conventions

Create branches from `main` using:
- `feature/<name>`
- `fix/<name>`
- `chore/<name>`

Examples:
- `feature/onboarding-flow`
- `fix/navigation-crash-on-start`
- `chore/update-flutter-sdk-constraints`

## Issue-First Workflow

1. Open or select an issue before implementation.
2. Confirm scope and acceptance criteria in the issue.
3. Create a branch following the naming convention.
4. Implement in small, focused commits.
5. Open a pull request and link the issue.

## PR Linking Guidance

Link PRs to issues in the PR description with:
- `Closes #123`
- `Fixes #123`
- `Resolves #123`

## Code Review Expectations

- Keep PRs scoped and easy to review.
- Ensure CI checks are passing before requesting review.
- Address feedback clearly and re-request review after updates.
- Merge only after required approvals and passing checks.

## Formatting, Lint, and Test Expectations

Run these locally before opening/updating a PR:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Definition of Done

Before merge, confirm:
- [ ] Issue is linked and acceptance criteria are met
- [ ] `dart format` passes with no changes required
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Docs/README are updated if setup or behavior changed
- [ ] Review feedback has been addressed
