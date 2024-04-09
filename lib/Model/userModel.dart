// ignore_for_file: file_names

import 'package:hive_flutter/hive_flutter.dart';

part 'userModel.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject{
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  UserModel({
    required this.uid,
    required this.name,
    required this.image,
  });
}
