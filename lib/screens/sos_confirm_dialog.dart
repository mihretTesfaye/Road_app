import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../widgets/primary_button.dart';

/// SOS Confirmation Dialog
class SOSConfirmDialog extends StatelessWidget {
  const SOSConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppTheme.sosBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 50,
                color: AppTheme.sosColor,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Title
            Text(
              'Send Emergency Alert?',
              style: AppTheme.heading2,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Description
            Text(
              'This will send an emergency alert to your contacts and emergency services with your current location.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacingXL),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacingM,
                      ),
                      side: const BorderSide(color: AppTheme.dividerColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: PrimaryButton(
                    text: 'Send SOS',
                    onPressed: () => _handleSOS(context),
                    backgroundColor: AppTheme.sosColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSOS(BuildContext context) {
    Navigator.pop(context); // Close confirmation dialog
    
    // Show success state
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SOSSuccessDialog(),
    );
  }
}

/// SOS Success State Dialog
class SOSSuccessDialog extends StatelessWidget {
  const SOSSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 50,
                color: AppTheme.successColor,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Title
            Text(
              'Emergency Alert Sent!',
              style: AppTheme.heading2,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Description
            Text(
              'Your emergency alert has been sent to your contacts and emergency services. Help is on the way!',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacingXL),
            
            // OK button
            PrimaryButton(
              text: 'OK',
              onPressed: () => Navigator.pop(context),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
