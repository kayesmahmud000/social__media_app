import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/providers/post_provider.dart';
import 'package:social_media_app/providers/stroy_provider.dart';
import 'package:social_media_app/screens/post_page.dart';
import 'package:social_media_app/widgets/logo.dart';
import 'package:social_media_app/widgets/post_card.dart';
import 'package:social_media_app/widgets/story_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final userId = context.read<AuthProvider>().currentUser?.id;
        if (userId != null) {
          context.read<PostProvider>().getPosts(userId);
          context.read<AuthProvider>().getUsers();
          context.read<StroyProvider>().getAllStories();
        }
      }
    });
  }

  void handleDelete(int postId, int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<PostProvider>().deletePost(postId, userId);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final postProvider = context.watch<PostProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PostPage()),
                        ),
                        icon: Icon(Icons.add, size: 28),
                      ),
                      Logo.logo(width: 110, bottom: -42, w: 100),
                      const Icon(Icons.search, size: 28),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: StorySection()),

          if (postProvider.isLoading)
            const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final post = postProvider.posts[index];
                return PostCard(
                  postId: post.id!,
                  userName: post.userName ?? "User",
                  title: post.content ?? "",
                  avatar: post.userAvatar,
                  imageUrl: post.imagePath,
                  timeStamp: post.timeStamp,
                  isLiked: post.isLiked,
                  likeCount: post.likeCount,
                  commentCount: post.commentCount ?? 0,
                  onLike: () {
                    context.read<PostProvider>().handleLike(
                      post.id!,
                      currentUser.id!,
                    );
                  },
                  onDelete: () {
                    handleDelete(post.id!, currentUser.id!);
                  },
                );
              }, childCount: postProvider.posts.length),
            ),
        ],
      ),
    );
  }
}
