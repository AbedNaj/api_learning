import 'package:happy_tech_mastering_api_with_flutter/core/api/end_point.dart';

class UserModel {
  final String? profilePic; // Change type to String?
  final String email;
  final String phone;
  final String name;
  final Map<String, dynamic> location;

  UserModel({
    required this.profilePic,
    required this.email,
    required this.phone,
    required this.name,
    required this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      // ignore: unnecessary_null_in_if_null_operators
      profilePic: jsonData['user'][ApiKey.profilePic],
      email: jsonData['user'][ApiKey.email],
      phone: jsonData['user'][ApiKey.phone],
      name: jsonData['user'][ApiKey.name],
      location: jsonData['user'][ApiKey.location],
    );
  }
}
