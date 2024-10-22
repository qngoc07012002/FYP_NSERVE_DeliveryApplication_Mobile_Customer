class User {
  String id;
  String phoneNumber;
  String email;
  String password;
  String fullName;
  String regionId;
  DateTime createAt;
  DateTime updateAt;

  User({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.fullName,
    required this.regionId,
    required this.createAt,
    required this.updateAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      fullName: json['fullName'],
      regionId: json['regionId'],
      createAt: DateTime.parse(json['createAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'fullName': fullName,
      'regionId': regionId,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }
}

