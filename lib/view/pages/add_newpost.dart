import 'package:flutter/material.dart';
import 'package:social_media_firebase/Database/Firebase_Ulits.dart';
import 'package:social_media_firebase/model/post_model.dart';
import 'package:social_media_firebase/model/user_model.dart';
import 'package:social_media_firebase/view/pages/componenet/custom_Textfield.dart';
import 'package:social_media_firebase/view/presentation/themes.dart';

class AddNewPost extends StatefulWidget {
  const AddNewPost({super.key});
  static const String routeName = 'add_new_post';
  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final String _image = 'assets/images/user.jpg';
  final String _imageURL = 'assets/images/leaf.jpg';
  Future<void> _addPost() async {
    if (_formKey.currentState!.validate()) {
      final newPost = PostModel(
        title: _titleController.text,
        summary: _summaryController.text,
        body: _bodyController.text,
        imageURL: _imageURL,
        postTime: DateTime.now(),
        reacts: 0,
        views: 0,
        author: UserModel(
          name: 'eman',
          email: 'eman@gmail.com',
          image: _image,
          followers: 0,
          joined: DateTime.now(),
          posts: 0,
        ),
        comments: [],
      );

      await FirebaseUtils.addPostToFireStore(newPost);
      setState(() {
        Navigator.pop(context);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post added successfully!')),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Post',
          style: MyTheme.title,
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              controller: _titleController,
              label: 'Title',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            CustomTextFormField(
              controller: _summaryController,
              label: 'Summary',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a summary';
                }
                return null;
              },
            ),
            CustomTextFormField(
              label: 'Body',
              controller: _bodyController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter body text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  await _addPost();
                },
                child: const Text(
                  'sumbit',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
