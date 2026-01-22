import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/chat_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/location_permission_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_dashboard_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

/// App routing configuration using go_router
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String locationPermission = '/location-permission';
  static const String dashboard = '/dashboard';
  static const String contacts = '/contacts';
  static const String messages = '/messages';
  static const String chat = '/chat';
  
  static GoRouter get router => _router;
  
  static final GoRouter _router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: locationPermission,
        name: 'location-permission',
        builder: (context, state) => const LocationPermissionScreen(),
      ),
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const MapDashboardScreen(),
      ),
      GoRoute(
        path: contacts,
        name: 'contacts',
        builder: (context, state) => const ContactsScreen(),
      ),
      GoRoute(
        path: messages,
        name: 'messages',
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: chat,
        name: 'chat',
        // expects state.extra to be a Map<String, dynamic> with contact data
        builder: (context, state) => ChatScreen(contactData: state.extra as Map<String, dynamic>?),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
