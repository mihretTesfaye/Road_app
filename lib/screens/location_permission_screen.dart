import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_theme.dart';
import '../routes.dart';
import '../widgets/primary_button.dart';

/// Enable Location screen with illustration and CTA
class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  PermissionStatus? _status;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final status = await Permission.locationWhenInUse.status;
    if (mounted) setState(() => _status = status);
  }

  Future<void> _requestPermission() async {
    setState(() => _isRequesting = true);
    final status = await Permission.locationWhenInUse.request();
    setState(() {
      _status = status;
      _isRequesting = false;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('location_shown_${user.uid}', true);
    }

    if (status.isGranted) {
      if (mounted) context.go(AppRoutes.dashboard);
    } else if (status.isPermanentlyDenied) {
      if (mounted) _showOpenSettingsDialog();
    } else if (status.isDenied) {
      if (mounted) _showPermissionDeniedSnack();
    }
  }

  void _showPermissionDeniedSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Location permission denied. Some features may be limited.',
        ),
      ),
    );
  }

  void _showOpenSettingsDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'Location permission has been permanently denied. Please open settings and enable location access to use all features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _status == null
        ? 'Checking permission...'
        : _status!.isGranted
        ? 'Location access granted'
        : _status!.isPermanentlyDenied
        ? 'Permission permanently denied'
        : 'Location access not granted';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          child: Column(
            children: [
              const Spacer(),

              // Illustration
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 96,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXXL),

              Text(
                'Enable Location',
                style: AppTheme.heading1,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacingM),

              Text(
                'We need your location to provide emergency and safety features. Please enable location access.',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacingL),

              _LocationBenefit(
                icon: Icons.emergency,
                text: 'Quick emergency response',
              ),
              const SizedBox(height: AppTheme.spacingM),
              _LocationBenefit(
                icon: Icons.near_me,
                text: 'Accurate location sharing',
              ),
              const SizedBox(height: AppTheme.spacingM),
              _LocationBenefit(
                icon: Icons.security,
                text: 'Enhanced safety features',
              ),

              const Spacer(),

              Text(
                statusText,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),

              PrimaryButton(
                text: _status?.isGranted == true
                    ? 'Continue'
                    : 'Enable Location',
                onPressed: _status?.isGranted == true
                    ? () => context.go(AppRoutes.dashboard)
                    : _requestPermission,
                isLoading: _isRequesting,
                width: double.infinity,
                icon: Icons.location_on,
              ),

              const SizedBox(height: AppTheme.spacingM),

              TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('location_shown_${user.uid}', true);
                  }
                  context.go(AppRoutes.dashboard);
                },
                child: const Text('Skip for now'),
              ),

              const SizedBox(height: AppTheme.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationBenefit extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LocationBenefit({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(child: Text(text, style: AppTheme.bodyMedium)),
      ],
    );
  }
}
