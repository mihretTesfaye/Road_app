import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_theme.dart';
import '../routes.dart';
import '../widgets/primary_button.dart';

/// Enable Location screen with illustration and CTA
class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Illustration placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 100,
                  color: AppTheme.primaryColor,
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingXXL),
              
              // Title
              Text(
                'Enable Location',
                style: AppTheme.heading1,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Description
              Text(
                'To provide you with the best safety and emergency services, we need access to your location.',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppTheme.spacingXL),
              
              // Benefits list
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
              
              // Enable Location button
              PrimaryButton(
                text: 'Enable Location',
                onPressed: () {
                  // In a real app, request location permission here
                  // For now, navigate to dashboard
                  context.go(AppRoutes.dashboard);
                },
                width: double.infinity,
                icon: Icons.location_on,
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Skip button
              TextButton(
                onPressed: () {
                  // Navigate to dashboard without location
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

  const _LocationBenefit({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
