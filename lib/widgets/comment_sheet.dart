import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/providers/comment_provider.dart';
import 'package:social_media_app/providers/post_provider.dart';
import 'package:social_media_app/usecases/comment_use_case.dart';

class CommentSheet extends StatefulWidget {
  final int postId;
  const CommentSheet({super.key, required this.postId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<CommentProvider>().getAllComment(widget.postId);
      }
    });
  }

  void _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final authProvider = context.read<AuthProvider>();
    final commentProvider = context.read<CommentProvider>();
    final postProvider = context.read<PostProvider>();

    final currentUser = authProvider.currentUser;
    if (currentUser == null) return;

    final commentDTO = CommentDTO(
      userId: currentUser.id!,
      postId: widget.postId,
      content: _commentController.text.trim(),
      timeStamp: DateTime.now().toString(),
    );

    final success = await commentProvider.createComment(commentDTO);

    if (!mounted) return;

    if (success) {
      _commentController.clear();
      postProvider.updatePostInList(widget.postId);
    }
  }

  String _formatCommentTime(String ts) {
    try {
      DateTime dt = DateTime.parse(ts);
      return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.day}/${dt.month}";
    } catch (e) {
      return "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            "Comments",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          Expanded(
            child: Consumer<CommentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.comments.isEmpty) {
                  return const Center(child: Text("No comments yet."));
                }

                return ListView.builder(
                  itemCount: provider.comments.length,
                  itemBuilder: (context, index) {
                    final comment = provider.comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: comment.userAvatar != null
                            ? (comment.userAvatar!.startsWith('http')
                                  ? NetworkImage(comment.userAvatar!)
                                  : FileImage(File(comment.userAvatar!))
                                        as ImageProvider)
                            : null,
                        child: comment.userAvatar == null
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            comment.userName ?? "User",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            _formatCommentTime(comment.timeStamp),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(comment.content),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _submitComment,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
