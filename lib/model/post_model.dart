import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:social_media_firebase/Database/Firebase_Ulits.dart';
import 'package:social_media_firebase/model/comment_model.dart';
import 'package:social_media_firebase/model/user_model.dart';

class PostModel {
  static const String collectionName = 'posts';
  String? id, title, summary, body, imageURL;
  final DateTime? postTime;
  int? reacts, views;
  final UserModel? author;
  final List<CommentModel?> comments;

  PostModel({
    this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.imageURL,
    required this.postTime,
    this.reacts,
    this.views,
    required this.author,
    required this.comments,
  });

  String get postTimeFormatted => DateFormat.yMMMMEEEEd().format(postTime!);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'body': body,
      'imageURL': imageURL,
      'postTime': Timestamp.fromDate(postTime!),
      'reacts': reacts,
      'views': views,
      'author': author!.toMap(),
      'comments': comments.map((comment) => comment!.toMap()).toList(),
    };
  }

  PostModel.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'] ?? '',
          title: data['title'] ?? '',
          summary: data['summary'] ?? '',
          body: data['body'] ?? '',
          imageURL: data['imageURL'] ?? '',
          postTime: (data['postTime'] as Timestamp).toDate(),
          reacts: data['reacts'] ?? 0,
          views: data['views'] ?? 0,
          author: UserModel.fromMap(data['author'] as Map<String, dynamic>),
          comments: (data['comments'] as List<dynamic>)
              .map((item) => CommentModel.fromMap(item as Map<String, dynamic>))
              .toList(),
        );

  Future<void> incrementViews() async {
    if (id == null) {
      print("Error: Post ID is null.");
      return;
    }

    try {
      await FirebaseUtils.updatePostStats(id!, views: 1);
      views = (views ?? 0) + 1;
    } catch (e) {
      print("Error updating views: $e");
    }
  }

  Future<void> incrementReacts() async {
    if (id == null) {
      print("Error: Post ID is null.");
      return;
    }

    try {
      await FirebaseUtils.updatePostStats(id!, reacts: 1);
      reacts = (reacts ?? 0) + 1;
    } catch (e) {
      print("Error updating reacts: $e");
    }
  }
}
