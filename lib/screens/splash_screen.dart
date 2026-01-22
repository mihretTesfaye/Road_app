import 'package:flutter/material.dart';///main skeleton
import 'package:go_router/go_router.dart';///navigation library
import '../app_theme.dart';//app theme 
import '../routes.dart';//route definition
import '../widgets/primary_button.dart';///using one button many times

/// Splash/Welcome screen with logo, tagline, and navigation buttons
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  
                  // Logo placeholder
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 60,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // App Name
                  Text(
                    'Tillash Roads',
                    style: AppTheme.heading1.copyWith(
                      color: Colors.white,
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Tagline
                  Text(
                    'Safety & Emergency\nLocation-Based Services',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(flex: 3),
                  
                  // Login Button
                  PrimaryButton(
                    text: 'Login',
                    onPressed: () => context.go(AppRoutes.login),
                    width: double.infinity,
                    backgroundColor: Colors.white,
                    textColor: AppTheme.primaryColor,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Signup Button
                  PrimaryButton(
                    text: 'Sign Up',
                    onPressed: () => context.go(AppRoutes.signup),
                    isOutlined: true,
                    backgroundColor: Colors.white,
                    textColor: Colors.white,
                    width: double.infinity,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
