import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_firebase/model/post_model.dart';

class FirebaseUtils {
  static CollectionReference<PostModel> getPostsCollection() {
    return FirebaseFirestore.instance
        .collection(PostModel.collectionName)
        .withConverter<PostModel>(
          fromFirestore: (snapshot, options) =>
              PostModel.fromMap(snapshot.data()!),
          toFirestore: (post, options) => post.toMap(),
        );
  }

  static Future<void> addPostToFireStore(PostModel post) async {
    var postCollection = getPostsCollection();
    DocumentReference<PostModel> docRef = postCollection.doc();
    post.id = docRef.id;
    post.reacts = post.reacts ?? 0;
    post.views = post.views ?? 0;
    await docRef.set(post);
  }

  static Future<void> updatePostStats(String postId,
      {int? reacts, int? views}) async {
    DocumentReference<PostModel> docRef = getPostsCollection().doc(postId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot<PostModel> snapshot = await transaction.get(docRef);

      if (snapshot.exists) {
        int newReacts = (snapshot.data()?.reacts ?? 0) + (reacts ?? 0);
        int newViews = (snapshot.data()?.views ?? 0) + (views ?? 0);

        transaction.update(docRef, {
          'reacts': newReacts,
          'views': newViews,
        });
      } else {
        throw Exception("Post not found");
      }
    }).catchError((error) {
      print("Failed to update post stats: $error");
    });
  }
}
