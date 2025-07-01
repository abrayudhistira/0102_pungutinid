class User {
  final int id;
  final String username;
  final String role;
  final String? photo;

  User({
    required this.id,
    required this.username,
    required this.role,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String? photo = json['photo'];
    if (photo != null && photo.isNotEmpty && !photo.startsWith('http')) {
      photo = 'http://192.168.1.21:3001/uploads/$photo';
    }
    return User(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      photo: photo,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "role": role,
        "photo": photo, // Tambahkan field photo jika ada
      };
}