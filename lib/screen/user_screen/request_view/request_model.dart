class GetEngineerProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String password;
  final String profileImage;
  final String idProof;
  final String status;
  final String userType;
  final bool available;

  GetEngineerProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    required this.profileImage,
    required this.idProof,
    required this.status,
    required this.userType,
    required this.available,
  });

  factory GetEngineerProfileModel.fromJson(Map<String, dynamic> json) {
    return GetEngineerProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      password: json['password'] ?? '',
      profileImage: json['profile_image'] ?? '',
      idProof: json['id_proof'] ?? '',
      status: json['status'] ?? '',
      userType: json['user_type'] ?? '',
      available: json['available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
      'profile_image': profileImage,
      'id_proof': idProof,
      'status': status,
      'user_type': userType,
      'available': available,
    };
  }
}
