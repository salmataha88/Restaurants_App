class User {
  final String name;
  final String email;
  final String? gender;
  final int? level;
  final String password;
  final String confirmPassword;
  final double longitude;
  final double latitude;
  final String? id;

  User({
    required this.name,
    required this.email,
    this.gender,
    this.level,
    required this.password,
    required this.confirmPassword,
    required this.longitude,
    required this.latitude,
    this.id
  });

 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      level: json['level'] ?? 0,
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      latitude: json['location']?['coordinates']?[1] ?? 0.0,
      longitude: json['location']?['coordinates']?[0] ?? 0.0,
      id: json['_id'],  // handle optional id
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'level': level,
      'password': password,
      'confirmPassword': confirmPassword,
      'location': {
        'longitude': longitude,
        'latitude': latitude,
      },
    };
  }

  @override
  String toString() {
    return 'User(name: $name, email: $email, gender: $gender, level: $level, password: $password, latitude: $latitude, longitude: $longitude , id: $id)';
  }
}
