import 'package:flutter/material.dart';
import 'package:state_change_demo/src/models/post.model.dart';
import 'package:state_change_demo/src/models/user.model.dart';
import 'package:state_change_demo/src/screens/rest_demo.dart';

class PostDetailDialog extends StatelessWidget {
  final Post post;
  final User? user;
  final PostController controller;

  const PostDetailDialog({required this.post, this.user, required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(post.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.body,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Post Created By: ${user?.name ?? 'Unknown'}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () async {
            await controller.deletePost(post.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
