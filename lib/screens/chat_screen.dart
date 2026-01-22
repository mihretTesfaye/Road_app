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
  bool _isContactRegistered = true;

  String? get contactId => widget.contactData?['id'] as String?;
  String get contactName => widget.contactData?['name'] ?? 'Contact';

  String? _chatIdFor(String uid1, String uid2) {
    // deterministic chat id so both users use same document
    if (uid1.compareTo(uid2) <= 0) {
      return '${uid1}_$uid2';
    }
    return '${uid2}_$uid1';
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || contactId == null) return const Stream.empty() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    final chatId = _chatIdFor(uid, contactId!);
    if (chatId == null) return const Stream.empty() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> _sendMessage(String text) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || contactId == null) return;
    final chatId = _chatIdFor(uid, contactId!);
    if (chatId == null) return;
    final msg = {
      'text': text,
      'senderId': uid,
      'timestamp': FieldValue.serverTimestamp(),
      'isSOS': false,
    };
    await _firestore.collection('chats').doc(chatId).collection('messages').add(msg);
    _controller.clear();
  }

  Future<void> _sendSOS() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || contactId == null) return;
    final chatId = _chatIdFor(uid, contactId!);
    if (chatId == null) return;
    final msg = {
      'text': 'SOS sent!',
      'senderId': uid,
      'timestamp': FieldValue.serverTimestamp(),
      'isSOS': true,
    };
    await _firestore.collection('chats').doc(chatId).collection('messages').add(msg);
  }

  @override
  void initState() {
    super.initState();
    // check if contact corresponds to a registered user
    final cid = contactId;
    if (cid != null) {
      FirebaseFirestore.instance.collection('users').doc(cid).get().then((doc) {
        setState(() {
          _isContactRegistered = doc.exists;
        });
      }).catchError((_) {});
    }
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
      appBar: AppBar(
        title: Text(contactName),
        actions: [
          if (!_isContactRegistered)
            TextButton.icon(
              onPressed: () {
                final email = widget.contactData?['email'] as String? ?? 'No email';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invite sent to $email')));
              },
              icon: const Icon(Icons.person_add, color: AppTheme.white),
              label: const Text('Invite', style: TextStyle(color: AppTheme.white)),
            ),
        ],
      ),
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
                    final senderId = d['senderId'] as String?;
                    final isSOS = d['isSOS'] as bool? ?? false;
                    final uid = _auth.currentUser?.uid;
                    final sentByUser = senderId != null && uid != null && senderId == uid;
                    return Align(
                      alignment: sentByUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSOS ? AppTheme.errorColor : (sentByUser ? AppTheme.primaryColor : AppTheme.surfaceColor),
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: AppTheme.bodyMedium.copyWith(
                                color: sentByUser || isSOS ? AppTheme.white : AppTheme.textPrimary,
                                fontWeight: isSOS ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (isSOS) ...[
                              const SizedBox(height: 6),
                              Text('SOS', style: AppTheme.bodySmall.copyWith(color: AppTheme.white, fontWeight: FontWeight.bold)),
                            ],
                          ],
                        ),
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
                  IconButton(
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) _sendMessage(text);
                    },
                    icon: const Icon(Icons.send),
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // SOS sends a special message
                      await _sendSOS();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SOS sent')));
                    },
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('SOS'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
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
