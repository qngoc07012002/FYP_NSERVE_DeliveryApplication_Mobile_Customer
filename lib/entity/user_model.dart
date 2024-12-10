class User {
  String id;
  String phoneNumber;
  String email;
  String fullName;
  String imgUrl;

  User({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.fullName,
    required this.imgUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      fullName: json['fullName'],
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'fullName': fullName,
      'imgUrl' : imgUrl,
    };
  }
}

