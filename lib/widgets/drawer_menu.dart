import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_theme.dart';
import '../routes.dart';

/// Side drawer menu widget
class DrawerMenu extends StatelessWidget {
  final String currentRoute;

  const DrawerMenu({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: AppTheme.spacingL,
              left: AppTheme.spacingL,
              right: AppTheme.spacingL,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryDark,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  'John Doe', // Dummy user name
                  style: AppTheme.heading3.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  'john.doe@example.com', // Dummy email
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerMenuItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: AppRoutes.dashboard,
                  currentRoute: currentRoute,
                  onTap: () {
                    Navigator.pop(context);
                    if (currentRoute != AppRoutes.dashboard) {
                      context.go(AppRoutes.dashboard);
                    }
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.person,
                  title: 'Profile',
                  route: '/profile', // Placeholder
                  currentRoute: currentRoute,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to profile (not implemented)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile screen coming soon')),
                    );
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.contacts,
                  title: 'My Contacts',
                  route: AppRoutes.contacts,
                  currentRoute: currentRoute,
                  onTap: () {
                    Navigator.pop(context);
                    if (currentRoute != AppRoutes.contacts) {
                      context.go(AppRoutes.contacts);
                    }
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  route: '/notifications', // Placeholder
                  currentRoute: currentRoute,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to notifications (not implemented)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications screen coming soon')),
                    );
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  route: '/help', // Placeholder
                  currentRoute: currentRoute,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to help (not implemented)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help & Support coming soon')),
                    );
                  },
                ),
                const Divider(height: 32),
                _DrawerMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  route: '/logout',
                  currentRoute: currentRoute,
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.login);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final String currentRoute;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.currentRoute,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentRoute == route;
    final color = isDestructive
        ? AppTheme.errorColor
        : (isSelected ? AppTheme.primaryColor : AppTheme.textPrimary);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: color,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
