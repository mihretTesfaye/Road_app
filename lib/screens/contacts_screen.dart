import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/contact_model.dart';
import '../widgets/contact_tile.dart';

/// Contacts screen with searchable contact list and add contact button
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ContactModel> _contacts = [];
  List<ContactModel> _filteredContacts = [];
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
    _listenContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _listenContacts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('contacts')
        .orderBy('name')
        .snapshots()
        .listen((snap) {
      final items = snap.docs.map((d) => ContactModel.fromMap(d.data())).toList();
      setState(() {
        _contacts = items;
        _filterContacts();
      });
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts.where((contact) {
          return contact.name.toLowerCase().contains(query) ||
              contact.phone.contains(query) ||
              (contact.email?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contact'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter full name',
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (Optional)',
                  hintText: 'Enter email address',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final contact = ContactModel(
                  id: id,
                  name: nameController.text,
                  phone: phoneController.text,
                  email: emailController.text.isEmpty ? null : emailController.text,
                );
                await _firestore
                    .collection('users')
                    .doc(user.uid)
                    .collection('contacts')
                    .doc(id)
                    .set(contact.toMap());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact added successfully')));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contacts'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: TextField(
              controller: _searchController,
                decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  borderSide: const BorderSide(color: AppTheme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  borderSide: const BorderSide(color: AppTheme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          
          // Contacts list
          Expanded(
            child: _filteredContacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contacts_outlined,
                          size: 64,
                          color: AppTheme.textHint,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No contacts yet'
                              : 'No contacts found',
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return ContactTile(
                        contact: contact,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${contact.name}')),
                          );
                        },
                        onDelete: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) return;
                          await _firestore
                              .collection('users')
                              .doc(user.uid)
                              .collection('contacts')
                              .doc(contact.id)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${contact.name} removed')));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddContactDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Contact'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
