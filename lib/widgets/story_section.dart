import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/helper/image_pick_helper.dart';
import 'package:social_media_app/models/story_model.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/providers/stroy_provider.dart';
import 'package:social_media_app/screens/stroy_preview_screen.dart';
import 'package:social_media_app/screens/stroy_view_screen.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});

  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  final ImagePickHelper _imageHelper = ImagePickHelper();

  void _handleImagePick() async {
    String? path = await _imageHelper.picAndSaveImage();
    if (path != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StroyPreviewScreen(imageFile: File(path)),
        ),
      );
    }
  }

  void _showStoryOptions(
    List<StoryModel> myStories,
    String? name,
    String? profile,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.remove_red_eye),
            title: const Text('View Your Story'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryViewScreen(
                    stories: myStories,
                    userName: name ?? "You",
                    userProfile: profile,
                    ownerId: myStories.first.userId,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_a_photo),
            title: const Text('Add New Story'),
            onTap: () {
              Navigator.pop(context);
              _handleImagePick();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<StroyProvider>().getAllStories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final storyProvider = context.watch<StroyProvider>();

    final currentUser = authProvider.currentUser;
    final userList = authProvider.users;
    final groupedStories = storyProvider.groupedStories;

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: userList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            final myStories = groupedStories[currentUser?.id];
            return GestureDetector(
              onTap: () {
                if (myStories != null && myStories.isNotEmpty) {
                  _showStoryOptions(
                    myStories,
                    "Your Story",
                    currentUser?.profileUrl,
                  );
                } else {
                  _handleImagePick();
                }
              },
              child: _buildStoryItem(
                name: "Your Story",
                image: currentUser?.profileUrl,
                isCurrentUser: true,
                hasStory: myStories != null && myStories.isNotEmpty,
              ),
            );
          } else {
            final user = userList[index - 1];
            if (user?.id == currentUser?.id) return const SizedBox.shrink();

            final userStories = groupedStories[user?.id];

            return GestureDetector(
              onTap: () {
                if (userStories != null && userStories.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryViewScreen(
                        stories: userStories,
                        userName: user?.userName ?? "User",
                        userProfile: user?.profileUrl,
                        ownerId: user!.id!,
                      ),
                    ),
                  );
                }
              },
              child: _buildStoryItem(
                name: user?.userName ?? "User",
                image: user?.profileUrl,
                isCurrentUser: false,
                hasStory: userStories != null && userStories.isNotEmpty,
              ),
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
    required bool hasStory,
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
                  gradient: hasStory
                      ? const LinearGradient(
                          colors: [Colors.purple, Colors.orange, Colors.yellow],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        )
                      : null,
                  border: !hasStory
                      ? Border.all(color: Colors.grey.shade300, width: 2)
                      : null,
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: (image != null && image.isNotEmpty)
                      ? (image.startsWith('http')
                            ? NetworkImage(image)
                            : FileImage(File(image)) as ImageProvider)
                      : null,
                  child: (image == null || image.isEmpty)
                      ? const Icon(Icons.person, size: 35, color: Colors.grey)
                      : null,
                ),
              ),
              if (isCurrentUser)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 75,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
