import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/comment_sheet.dart';


class PostCard extends StatelessWidget {
  final int postId;
  final String title;
  final String? imageUrl;
  final String? avatar;
  final String userName;
  final String timeStamp;
  final bool isLiked;
  final int likeCount;
  final int commentCount; 
  final VoidCallback? onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const PostCard({
    super.key,
    required this.postId,
    required this.title,
    required this.userName,
    this.avatar,
    this.imageUrl,
    required this.timeStamp,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0, 
    this.onLike,
    this.onDelete,
    this.onEdit,
  });

  
  String _formatTimeStamp(String ts) {
    try {
      DateTime dateTime = DateTime.parse(ts);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}  ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return ts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: avatar != null
                    ? (avatar!.startsWith('http')
                        ? NetworkImage(avatar!)
                        : FileImage(File(avatar!)) as ImageProvider)
                    : null,
                child: avatar == null ? const Icon(Icons.person, size: 20) : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _formatTimeStamp(timeStamp),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) onEdit!();
                  if (value == 'delete' && onDelete != null) onDelete!();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 8),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Delete", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

       
        if (imageUrl != null && imageUrl!.isNotEmpty)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: Image.file(
              File(imageUrl!),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 200,
                child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
              ),
            ),
          ),

      
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              // Like Button
              IconButton(
                onPressed: onLike,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 26,
                  color: isLiked ? Colors.red : Colors.black,
                ),
              ),
              
              // Comment Button with Count
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CommentSheet(postId: postId),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 24),
                      if (commentCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            '$commentCount',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined, size: 24),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border, size: 26),
              ),
            ],
          ),
        ),

        if (likeCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '$likeCount likes',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 15),
              children: [
                TextSpan(
                  text: '$userName ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: title),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}