import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/providers/post_provider.dart';
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
        Provider.of<PostProvider>(context, listen: false).getPosts();
      }
    });
  }

  void handleDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<PostProvider>().deletePost(id);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Deleting post..."),
                  duration: Duration(seconds: 1),
                ),
              );
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

    final allPosts = postProvider.posts;

    if (authProvider.currentUser == null) {
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
                      const Icon(Icons.add, size: 28),
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
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final post = allPosts[index];
                return PostCard(
                  userName: post.userName ?? "User",
                  title: post.content ?? "",
                  avatar: post.userAvatar,
                  imageUrl: post.imagePath,
                  onDelete: () {
                    if (post.id != null) {
                      handleDelete(post.id!);
                    }
                  },
                );
              }, childCount: allPosts.length),
            ),
        ],
      ),
    );
  }
}
