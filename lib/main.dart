import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'firebase_options.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppEntry());
}

/// AppEntry handles Firebase initialization and shows an actionable error
/// UI when configuration is missing or initialization fails.
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  String? _error;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    _initFirebase();
  }

  Future<void> _initFirebase() async {
    setState(() {
      _initializing = true;
      _error = null;
    });

    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      setState(() {
        _initializing = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _initializing = false;
        _error = e.toString();
      });
      // Helpful console output for debugging
      print('Firebase.initializeApp() failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Configuration Error')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Firebase initialization failed.', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(
                  'Reason: $_error',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
                const SizedBox(height: 16),
                const Text('How to fix', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('1) Ensure firebase_options.dart contains entries for the current platform.'),
                const SizedBox(height: 4),
                  SelectableText('dart pub global activate flutterfire_cli'),
                const SizedBox(height: 4),
                  SelectableText('flutterfire configure --project=<YOUR_FIREBASE_PROJECT_ID>'),
                const SizedBox(height: 12),
                const Text('Example commands:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SelectableText('dart pub global activate flutterfire_cli'),
                const SizedBox(height: 4),
                SelectableText('flutterfire configure --project=<YOUR_FIREBASE_PROJECT_ID>'),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _initFirebase,
                  icon: const Icon(Icons.refresh),   
                  label: const Text('Retry initialization'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // Open local docs file path (user can open docs/FIREBASE_SETUP.md in editor)
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('See docs/FIREBASE_SETUP.md for detailed steps')));
                  },
                  child: const Text('Open setup instructions'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Tara App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRoutes.router,
    );
  }
}
