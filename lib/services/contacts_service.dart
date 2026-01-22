import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/contact_model.dart';

/// Simple local caching for contacts using SharedPreferences.
class ContactsService {
  static const _prefix = 'cached_contacts_';

  static Future<List<ContactModel>> loadLocalContacts(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$uid';
    final jsonStr = prefs.getString(key);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final list = json.decode(jsonStr) as List<dynamic>;
    return list
        .map((e) => ContactModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<void> saveLocalContacts(String uid, List<ContactModel> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$uid';
    final list = contacts.map((c) => c.toMap()).toList();
    await prefs.setString(key, json.encode(list));
  }

  static Future<void> addLocalContact(String uid, ContactModel contact) async {
    final current = await loadLocalContacts(uid);
    current.add(contact);
    await saveLocalContacts(uid, current);
  }

  static Future<void> removeLocalContact(String uid, String id) async {
    final current = await loadLocalContacts(uid);
    current.removeWhere((c) => c.id == id);
    await saveLocalContacts(uid, current);
  }
}
