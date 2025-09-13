class User {
  final int? id;
  final String name;
  final String email;
  final String? avatar;

  const User({this.id, required this.name, required this.email, this.avatar});

  User copyWith({int? id, String? name, String? email, String? avatar}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  static User fromMap(Map<String, Object?> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String?,
    );
  }
}
