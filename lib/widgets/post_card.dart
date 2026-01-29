import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? avatar;
  final String userName;

  const PostCard({
    super.key,
    required this.title,
    required this.userName,
    this.avatar,
    this.imageUrl,
  });

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
                backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
                child: avatar == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 10),
              Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.more_vert),
            ],
          ),
        ),

        if (imageUrl != null)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 400),
            child: Image.network(imageUrl!, fit: BoxFit.cover),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
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

        const SizedBox(height: 15),
      ],
    );
  }
}
