class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status; // Tambahkan field status

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status, // Jadikan parameter wajib
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    role: json['role'],
    status: json['status'] ?? 'pending', // default pending jika kosong
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'status': status, // simpan status ke Firestore
  };
}
