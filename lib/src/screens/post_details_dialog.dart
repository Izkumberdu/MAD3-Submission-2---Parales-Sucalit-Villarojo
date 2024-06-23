import 'package:flutter/material.dart';
import 'package:state_change_demo/src/models/post.model.dart';
import 'package:state_change_demo/src/models/user.model.dart';
import 'package:state_change_demo/src/screens/rest_demo.dart';

class PostDetailDialog extends StatefulWidget {
  final Post post;
  final User? user;
  final PostController controller;

  const PostDetailDialog({required this.post, this.user, required this.controller, Key? key}) : super(key: key);

  @override
  _PostDetailDialogState createState() => _PostDetailDialogState();
}

class _PostDetailDialogState extends State<PostDetailDialog> {
  late Post post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

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
              'Post Created By: ${widget.user?.name ?? 'Unknown'}',
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
          child: const Text('Edit'),
          onPressed: () async {
            bool? result = await EditPostDialog.show(context, controller: widget.controller, post: post);
            if (result == true) {
              setState(() {
                post = widget.controller.posts[post.id.toString()]!;
              });
            }
          },
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () async {
            await widget.controller.deletePost(post.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class EditPostDialog extends StatefulWidget {
  static show(BuildContext context, {required PostController controller, required Post post}) =>
      showDialog(
          context: context, builder: (dContext) => EditPostDialog(controller, post));
  const EditPostDialog(this.controller, this.post, {super.key});

  final PostController controller;
  final Post post;

  @override
  State<EditPostDialog> createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late TextEditingController bodyC, titleC;

  @override
  void initState() {
    super.initState();
    bodyC = TextEditingController(text: widget.post.body);
    titleC = TextEditingController(text: widget.post.title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: const Text("Edit post"),
      actions: [
        ElevatedButton(
          onPressed: () async {
            await widget.controller.updatePost(
                id: widget.post.id, title: titleC.text.trim(), body: bodyC.text.trim());
            Navigator.of(context).pop(true); // Pass true to indicate changes
          },
          child: const Text("Save"),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Title"),
          Flexible(
            child: TextFormField(
              controller: titleC,
            ),
          ),
          const Text("Content"),
          Flexible(
            child: TextFormField(
              controller: bodyC,
            ),
          ),
        ],
      ),
    );
  }
}
