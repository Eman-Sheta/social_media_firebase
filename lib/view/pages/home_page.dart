import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_firebase/model/post_model.dart';
import 'package:social_media_firebase/model/user_model.dart';
import 'package:social_media_firebase/view/pages/add_newpost.dart';
import 'package:social_media_firebase/view/presentation/themes.dart';
import 'package:social_media_firebase/view/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(PostModel.collectionName)
          .orderBy('postTime', descending: false)
          .get();
      final posts = snapshot.docs.map((doc) {
        final data = doc.data();
        return PostModel(
            id: data['id'],
            title: data['title'],
            summary: data['summary'],
            body: data['body'],
            imageURL: data['imageURL'],
            postTime: (data['postTime'] as Timestamp).toDate(),
            reacts: data['reacts'],
            views: data['views'],
            author: UserModel(
              id: data['author']['id'],
              name: data['author']['name'],
              email: data['author']['email'],
              image: data['author']['image'],
              followers: data['author']['followers'],
              joined: (data['author']['joined'] as Timestamp).toDate(),
              posts: data['author']['posts'],
            ),
            comments: []);
      }).toList();

      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load posts: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leaf",
          style: MyTheme.title,
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _fetchPosts,
                  child: ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostCard(postData: _posts[index]);
                    },
                  ),
                ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: ClipOval(
          child: Container(
            color: Colors.green,
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.pushNamed(context, AddNewPost.routeName);
                _fetchPosts();
              },
            ),
          ),
        ),
      ),
    );
  }
}
