class User {
  final int id;
  final String? username;
  final String? role;
  final String photo;
  final String? fullname;
  final String? email;
  final String? address;
  final String? phone;

  User({
    required this.id,
    this.username,
    this.role,
    required this.photo,
    this.fullname,
    this.email,
     this.address,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String? photo = json['photo'];
    if (photo != null && photo.isNotEmpty && !photo.startsWith('http')) {
      photo = 'http://10.0.2.2:3001/uploads/$photo';
    }
    return User(
      id: json['user_id'], // sesuaikan dengan field backend
      username: json['username'],
      role: json['role'],
      photo: photo ?? '',
      fullname: json['fullname'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": id,
        "username": username,
        "role": role,
        "photo": photo,
        "fullname": fullname,
        "email": email,
        "address": address,
        "phone": phone,
      };
}