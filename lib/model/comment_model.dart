import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_firebase/model/user_model.dart';

class CommentModel {
  static const String collectionName = 'comments';
  final UserModel? user;
  final String? comment;
  final DateTime? time;

  const CommentModel({
    required this.user,
    required this.comment,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user!.toMap(),
      'comment': comment,
      'time': Timestamp.fromDate(time!),
    };
  }

  CommentModel.fromMap(Map<String, dynamic> data)
      : this(
          user: UserModel.fromMap(data['user'] as Map<String, dynamic>),
          comment: data['comment'] ?? '',
          time: (data['time'] as Timestamp).toDate(),
        );
}
