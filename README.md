# Nextway

The delivery app of the [Nextway](https://github.com/orgs/next-way/) project.

## Getting Started

### IMPORTANT:

Initial setup

```
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Environment variables

When running locally, it sometimes useful to test API connections on a local setup.

- **API_ENV** Determines whether to load `api_env.dev.yaml` if the value is "dev" (default). Otherwise, only `api_env.yaml` is loaded.

This command creates the generated files that parse each Record from Firestore into a schema object.

### Getting started continued:

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
