import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? number;
  String? department;
  String? password;
  String? joinDate;

  UserModel({
    required this.name,
    required this.email,
    required this.number,
    required this.department,
    this.password,
    this.joinDate,
    this.id,
  });

  factory UserModel.fromfirestore(DocumentSnapshot data) {
    return UserModel(
      name: data['username'],
      email: data['email'],
      number: data['number'],
      department: data['department'],
      password: data['password'],
      joinDate: data['joinDate'],
      id: data['id'],
    );
  }

  Map<String, dynamic> toFirestrore() {
    return {
      'name': name,
      'email': email,
      'number': number,
      'department': department,
      'password': password,
      'joinDate': joinDate,
      'id': id,
    };
  }
}
