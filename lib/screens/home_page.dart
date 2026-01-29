import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/widgets/logo.dart';
import 'package:social_media_app/widgets/post_card.dart';
import 'package:social_media_app/widgets/story_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String?>> dummyPosts = [
    {
      "userName": "sakib_99",
      "title": "The Sky Is Beautiful!  #nature #sky",
      "avatar": "https://randomuser.me/api/portraits/men/1.jpg",
      "imageUrl":
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800",
    },
    {
      "userName": "anika_travels",
      "title": "Missing the mountain vibes. ",
      "avatar": "https://randomuser.me/api/portraits/women/2.jpg",
      "imageUrl":
          "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
    },
    {
      "userName": "foodie_bhai",
      "title": "Best Burger in town! ",
      "avatar": "https://randomuser.me/api/portraits/men/3.jpg",
      "imageUrl":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
    },
    {
      "userName": "tech_geek",
      "title": "My new setup is finally ready. ",
      "avatar": "https://randomuser.me/api/portraits/men/4.jpg",
      "imageUrl":
          "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800",
    },
  ];
  @override
  Widget build(BuildContext context) {
    AuthProvider provider = context.watch<AuthProvider>();

    if (provider.currentUser == null) {
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

          // const SliverToBoxAdapter(
          //   child: Divider(thickness: 0.5, color: Colors.grey),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final post = dummyPosts[index];
              return PostCard(
                userName: post['userName']!,
                title: post['title']!,
                avatar: post['avatar'],
                imageUrl: post['imageUrl'],
              );
            }, childCount: dummyPosts.length),
          ),
        ],
      ),
    );
  }
}
