# Firebase setup for Tara App

This document explains how to configure Firebase for this Flutter project and fix the `CONFIGURATION_NOT_FOUND` / "Internal error has occurred" issue.

Prerequisites
- You must have the Firebase project created (note the project id).
- Install Flutter and Dart SDKs.

Steps

1) Install the FlutterFire CLI (if not already installed):

```bash
dart pub global activate flutterfire_cli
```

Make sure the `~/.pub-cache/bin` is in your PATH so `flutterfire` is runnable.

2) Run the interactive configuration for your Firebase project:

```bash
flutterfire configure --project=<YOUR_FIREBASE_PROJECT_ID>
```

Choose the platforms you want (Android, iOS, web). This will generate or update `lib/firebase_options.dart` and give you guidance about `google-services.json` and `GoogleService-Info.plist` placement.

3) Android specific
- Place the generated `google-services.json` into `android/app/google-services.json`.
- Ensure `applicationId`/`android:label` in `android/app/src/main/AndroidManifest.xml` matches the Firebase app if required.

4) iOS specific
- Place the `GoogleService-Info.plist` into `ios/Runner/` and add it to Xcode Runner target.

5) Web specific
- The `firebase_options.dart` will contain web configuration. Ensure your web index.html includes any required scripts (FlutterFire usually handles this via `firebase_options.dart`).

6) Desktop (Windows/macOS/Linux)
- The FlutterFire CLI may not generate desktop configs by default. If you need desktop support, run the CLI and include the desktop platforms when prompted, or configure `firebase_options.dart` manually.

7) Rebuild and run the app

```bash
flutter pub get
flutter run
```

If you still see errors, run the app from terminal to capture console logs and paste any `Firebase.initializeApp()` failures into an issue or share them with your developer.

Firestore security rules
- For development, you may allow read/write for authenticated users only. Example rule (adjust as needed):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /contacts/{contactId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

This ensures users can only access their own `users/{uid}` document and `users/{uid}/contacts`.

If you want me to run `flutterfire configure` steps for you, tell me which Firebase project id and which platforms (android, ios, web) you want configured and I will provide exact commands and next steps.