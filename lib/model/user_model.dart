import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserModel {
  static const String collectionName = 'users';
  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final int? followers;
  final DateTime? joined;
  final int? posts;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.followers,
    required this.joined,
    required this.posts,
  });

  String get postTimeFormatted => DateFormat.yMMMMEEEEd().format(joined!);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'followers': followers,
      'joined': Timestamp.fromDate(joined!),
      'posts': posts,
    };
  }

  UserModel.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          image: data['image'] ?? '',
          followers: data['followers'] ?? 0,
          joined: (data['joined'] as Timestamp).toDate(),
          posts: data['posts'] ?? 0,
        );
}
