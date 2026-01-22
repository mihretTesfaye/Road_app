import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show
        GoogleMap,
        GoogleMapController,
        CameraPosition,
        LatLng,
        MapType,
        Marker,
        MarkerId,
        InfoWindow;
import 'package:go_router/go_router.dart';
import '../app_theme.dart';
import '../routes.dart';
import '../widgets/drawer_menu.dart';
import 'sos_confirm_dialog.dart';
import '../utils/maps_check_stub.dart'
    if (dart.library.html) '../utils/maps_check_web.dart';

/// Main Dashboard with Google Maps integration
class MapDashboardScreen extends StatefulWidget {
  const MapDashboardScreen({super.key});

  @override
  State<MapDashboardScreen> createState() => _MapDashboardScreenState();
}

class _MapDashboardScreenState extends State<MapDashboardScreen> {
  int _currentIndex = 0;
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(currentRoute: AppRoutes.dashboard),
      appBar: AppBar(
        title: const Text('Tillash Roads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Maps or Placeholder for Windows
          _buildMapWidget(),

          // SOS Button (Floating Action Button)
          Positioned(
            bottom: 100,
            right: 20,
            child: _SOSButton(onPressed: () => _showSOSDialog(context)),
          ),

          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() => _currentIndex = index);
                  if (index == 1) {
                    // Navigate to contacts
                    context.go(AppRoutes.contacts);
                  } else if (index == 2) {
                    // History tab
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('History coming soon')),
                    );
                    setState(() => _currentIndex = 0);
                  } else if (index == 3) {
                    // Settings tab
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings coming soon')),
                    );
                    setState(() => _currentIndex = 0);
                  }
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppTheme.primaryColor,
                unselectedItemColor: AppTheme.textSecondary,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.contacts),
                    label: 'Contacts',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapWidget() {
    // Google Maps Flutter doesn't support Windows desktop
    // Show a placeholder map for Windows
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      return Container(
        color: AppTheme.backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 64, color: AppTheme.textSecondary),
              const SizedBox(height: 16),
              Text(
                'Map View',
                style: AppTheme.heading2.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Google Maps is not available on desktop.\nUse Android, iOS, or Web to view maps.',
                textAlign: TextAlign.center,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Use Google Maps for Android, iOS, and Web
    // Default location (placeholder - in production, use actual user location)
    final initialPosition = CameraPosition(
      target: LatLng(9.1450, 38.7667), // Addis Ababa, Ethiopia (example)
      zoom: 14.0,
    );

    // On web, if the Maps JS API hasn't loaded (window.google.maps),
    // show a safe placeholder instead of the GoogleMap widget so the
    // page doesn't throw a TypeError and appear to hang.
    if (kIsWeb) {
      try {
        if (!isMapsLoaded()) {
          return Container(
            color: AppTheme.backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64, color: AppTheme.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'Map is unavailable on web (Maps JS not loaded)',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please ensure your Google Maps API key is set in web/index.html',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      } catch (_) {
        // If any error checking maps, fall through to try rendering map.
      }
    }

    return GoogleMap(
      initialCameraPosition: initialPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      markers: {
        // Example markers (in production, these would be real emergency locations)
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(9.1450, 38.7667),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      },
    );
  }

  void _showSOSDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SOSConfirmDialog(),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _SOSButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SOSButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.sosColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.sosColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(35),
          child: const Center(
            child: Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
