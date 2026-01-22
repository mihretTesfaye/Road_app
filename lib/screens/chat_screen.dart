import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? contactData;
  const ChatScreen({super.key, this.contactData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _controller = TextEditingController();

  String? get contactId => widget.contactData?['id'] as String?;
  String get contactName => widget.contactData?['name'] ?? 'Contact';

  Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || contactId == null) {
      // empty stream
      return const Stream.empty() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    }
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .doc(contactId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> _sendMessage(String text) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || contactId == null) return;
    final msg = {
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'sentByUser': true,
    };
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .doc(contactId)
        .collection('messages')
        .add(msg);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (contactId == null) {
      return Scaffold(appBar: AppBar(title: const Text('Chat')), body: Center(child: Text('Contact not found', style: AppTheme.bodyLarge)));
    }

    return Scaffold(
      appBar: AppBar(title: Text(contactName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messagesStream(),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final d = docs[index].data();
                    final text = d['text'] as String? ?? '';
                    final sentByUser = d['sentByUser'] as bool? ?? false;
                    return Align(
                      alignment: sentByUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: sentByUser ? AppTheme.primaryColor : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Text(text, style: AppTheme.bodyMedium.copyWith(color: sentByUser ? AppTheme.white : AppTheme.textPrimary)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  ElevatedButton(
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) _sendMessage(text);
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
