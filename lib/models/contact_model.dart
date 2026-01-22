class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final bool isEmergency;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.isEmergency = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'isEmergency': isEmergency,
      };

  factory ContactModel.fromMap(Map<String, dynamic> m) => ContactModel(
        id: m['id'] as String,
        name: m['name'] as String,
        phone: m['phone'] as String,
        email: m['email'] as String?,
        isEmergency: m['isEmergency'] as bool? ?? false,
      );
}
