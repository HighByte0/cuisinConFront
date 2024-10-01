class UserInfoModel {
  int id;
  String name;
  String email;
  String phone;
  int orderCount;
  String autoEntrepreneurNumber; // Use camelCase for variable names

  UserInfoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.orderCount,
    required this.autoEntrepreneurNumber, 
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'] ?? 0, // Provide default value if null
      name: json['f_name'] ?? '', // Provide default value if null
      email: json['email'] ?? '', // Provide default value if null
      phone: json['phone'] ?? '', // Provide default value if null
      orderCount: json['order_count'] ?? 0, // Provide default value if null
      autoEntrepreneurNumber: json['auto_entrepreneur_number'] ?? '', // Provide default value if null
    );
  }

  @override
  String toString() {
    return 'UserInfoModel(id: $id, name: $name, email: $email, phone: $phone, orderCount: $orderCount, autoEntrepreneurNumber: $autoEntrepreneurNumber)';
  }
}
