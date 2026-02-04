import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    final List<String> dummyUsers = [
      "Rahim",
      "Karim",
      "Sakib",
      "Tamim",
      "Anika",
      "Rahim",
      "Karim",
      "Sakib",
      "Tamim",
      "Anika",
    ];

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: dummyUsers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildStoryItem(
              name: "Your Story",
              image: currentUser?.profileUrl,
              isCurrentUser: true,
            );
          } else {
            return _buildStoryItem(
              name: dummyUsers[index - 1],
              image: null,
              isCurrentUser: false,
            );
          }
        },
      ),
    );
  }

  Widget _buildStoryItem({
    required String name,
    String? image,
    required bool isCurrentUser,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isCurrentUser
                      ? null
                      : const LinearGradient(
                          colors: [Colors.purple, Colors.orange, Colors.yellow],
                        ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: image != null
                      ? (image.startsWith('http')
                            ? NetworkImage(image)
                            : FileImage(File(image)) as ImageProvider)
                      : null,
                  child: image == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
              ),

              if (isCurrentUser)
                Positioned(
                  bottom: 4,
                  right: 4,

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),

          Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
