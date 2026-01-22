class AppUser {
  final String uid;
  final String name;
  final String email;
  final String? phone;

  AppUser({required this.uid, required this.name, required this.email, this.phone});

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
      };

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
        uid: m['uid'] as String,
        name: m['name'] as String,
        email: m['email'] as String,
        phone: m['phone'] as String?,
      );
}
