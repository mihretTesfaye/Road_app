import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../app_theme.dart';
import '../models/contact_model.dart';
import '../routes.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<ContactModel>> _contactsStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map((d) => ContactModel.fromMap(d.data())).toList());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _latestSosStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('sos_alerts')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty ? snap.docs.first : FirebaseFirestore.instance.doc('users/$uid').snapshots().first as DocumentSnapshot<Map<String, dynamic>>);
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Messages')),
        body: Center(child: Text('Please log in to view messages', style: AppTheme.bodyLarge)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: Column(
        children: [
          // SOS summary card (latest)
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestore
                .collection('users')
                .doc(user.uid)
                .collection('sos_alerts')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData || snap.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Card(
                    child: ListTile(
                      leading: SvgPicture.asset('assets/icons/sos.svg', width: 36, height: 36, color: AppTheme.sosColor),
                      title: const Text('No SOS alerts yet'),
                      subtitle: const Text('When you send an SOS, a summary will appear here.'),
                    ),
                  ),
                );
              }

              final data = snap.data!.docs.first.data();
              final ts = (data['timestamp'] as Timestamp?)?.toDate();
              final recipients = (data['recipients'] as List?)?.cast<String>() ?? [];

              return Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Card(
                  child: ListTile(
                    leading: SvgPicture.asset('assets/icons/sos.svg', width: 36, height: 36, color: AppTheme.sosColor),
                    title: Text('SOS sent to ${recipients.length} contact(s)'),
                    subtitle: Text(ts != null ? 'Sent ${ts.toLocal()}' : 'Sent'),
                  ),
                ),
              );
            },
          ),

          // Contacts list for messaging
          Expanded(
            child: StreamBuilder<List<ContactModel>>(
              stream: _contactsStream(user.uid),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final contacts = snap.data!;
                if (contacts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/contacts.svg', width: 64, height: 64, color: AppTheme.textHint),
                        const SizedBox(height: AppTheme.spacingM),
                        Text('No contacts yet', style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: contacts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final c = contacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : '?', style: AppTheme.bodyLarge.copyWith(color: AppTheme.primaryColor)),
                      ),
                      title: Text(c.name, style: AppTheme.bodyLarge),
                      subtitle: Text(c.phone, style: AppTheme.bodySmall),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to chat screen with contact data
                        context.go(AppRoutes.chat, extra: c.toMap());
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
