import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Contact model for dummy data
class Contact {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? avatar;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatar,
  });
}

/// Contact tile widget for displaying contacts in a list
class ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ContactTile({
    super.key,
    required this.contact,
    this.onTap,
    this.onDelete,
  });

  String get _initials {
    final names = contact.name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return contact.name.substring(0, contact.name.length > 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: contact.avatar != null
              ? ClipOval(
                  child: Image.network(
                    contact.avatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildInitialsAvatar(),
                  ),
                )
              : _buildInitialsAvatar(),
        ),
        title: Text(
          contact.name,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              contact.phone,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            if (contact.email != null) ...[
              const SizedBox(height: AppTheme.spacingXS / 2),
              Text(
                contact.email!,
                style: AppTheme.bodySmall,
              ),
            ],
          ],
        ),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
                onPressed: onDelete,
              )
            : const Icon(Icons.chevron_right, color: AppTheme.textHint),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Text(
      _initials,
      style: AppTheme.bodyLarge.copyWith(
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
