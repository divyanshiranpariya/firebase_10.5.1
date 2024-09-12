import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  int id;
  String name;
  String email;
  int age;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });
}
