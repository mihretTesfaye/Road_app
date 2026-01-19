import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/contact_tile.dart';

/// Contacts screen with searchable contact list and add contact button
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _loadDummyContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDummyContacts() {
    // Dummy contact data
    _contacts = [
      Contact(
        id: '1',
        name: 'John Smith',
        phone: '+251 911 234 567',
        email: 'john.smith@example.com',
      ),
      Contact(
        id: '2',
        name: 'Sarah Johnson',
        phone: '+251 912 345 678',
        email: 'sarah.j@example.com',
      ),
      Contact(
        id: '3',
        name: 'Michael Brown',
        phone: '+251 913 456 789',
        email: 'michael.brown@example.com',
      ),
      Contact(
        id: '4',
        name: 'Emily Davis',
        phone: '+251 914 567 890',
        email: 'emily.davis@example.com',
      ),
      Contact(
        id: '5',
        name: 'David Wilson',
        phone: '+251 915 678 901',
        email: 'david.w@example.com',
      ),
      Contact(
        id: '6',
        name: 'Lisa Anderson',
        phone: '+251 916 789 012',
        email: 'lisa.a@example.com',
      ),
      Contact(
        id: '7',
        name: 'Robert Taylor',
        phone: '+251 917 890 123',
        email: 'robert.t@example.com',
      ),
      Contact(
        id: '8',
        name: 'Maria Garcia',
        phone: '+251 918 901 234',
        email: 'maria.g@example.com',
      ),
    ];
    _filteredContacts = _contacts;
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
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                final newContact = Contact(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  phone: phoneController.text,
                  email: emailController.text.isEmpty
                      ? null
                      : emailController.text,
                );
                setState(() {
                  _contacts.add(newContact);
                  _filterContacts();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact added successfully')),
                );
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
                          // Show contact details or actions
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected: ${contact.name}'),
                            ),
                          );
                        },
                        onDelete: () {
                          setState(() {
                            _contacts.removeWhere((c) => c.id == contact.id);
                            _filterContacts();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${contact.name} removed'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  setState(() {
                                    _contacts.add(contact);
                                    _filterContacts();
                                  });
                                },
                              ),
                            ),
                          );
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
