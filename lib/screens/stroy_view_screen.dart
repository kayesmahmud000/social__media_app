import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/story_model.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/providers/stroy_provider.dart'; 

class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final String userName;
  final String? userProfile;
  final int ownerId;

  const StoryViewScreen({
    super.key,
    required this.stories,
    required this.userName,
    this.userProfile,
    required this.ownerId,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  int _currentIndex = 0;
  double _percent = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
   
    _markStoryAsRead();
  }

 
  void _markStoryAsRead() {
    final authProvider = context.read<AuthProvider>();
    final storyProvider = context.read<StroyProvider>();
    final currentUserId = authProvider.currentUser?.id;
    final storyId = widget.stories[_currentIndex].id;

    if (currentUserId != null && storyId != null) {
     
      if (widget.ownerId != currentUserId) {
        storyProvider.markAsViewed(storyId, currentUserId);
      }
    }
  }

  void _startTimer() {
    _timer?.cancel(); 
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_percent < 1) {
          _percent += 0.01;
        } else {
          _nextStory();
        }
      });
    });
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
        _percent = 0;
      });
      _markStoryAsRead(); 
    } else {
      _timer?.cancel();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthProvider>().currentUser?.id;
    final bool isMyStory = widget.ownerId == currentUserId;
    final currentStoryId = widget.stories[_currentIndex].id;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
         
          GestureDetector(
            onTap: _nextStory,
            child: Center(
              child: Image.file(
                File(widget.stories[_currentIndex].mediaUrl!),
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),

        
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Row(
              children: widget.stories.map((s) {
                int index = widget.stories.indexOf(s);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: LinearProgressIndicator(
                      value: index == _currentIndex
                          ? _percent
                          : (index < _currentIndex ? 1.0 : 0.0),
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        
          Positioned(
            top: 70,
            left: 20,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: widget.userProfile != null
                      ? (widget.userProfile!.startsWith('http') 
                          ? NetworkImage(widget.userProfile!) 
                          : FileImage(File(widget.userProfile!)) as ImageProvider)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.userName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

        
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: isMyStory 
                ? _buildViewsCounter(currentStoryId) 
                : _buildReactBar(),
          ),
        ],
      ),
    );
  }

  
  Widget _buildViewsCounter(int? storyId) {
    return Consumer<StroyProvider>(
      builder: (context, provider, child) {
      
        final count = provider.storyViewCounts[storyId] ?? 0;

        return InkWell(
          onTap: () async {
           
            if (storyId != null) {
              final viewers = await provider.getViewerList(storyId);
              _showViewerListSheet(viewers);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.remove_red_eye, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                "Seen by $count",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }


  void _showViewerListSheet(List<Map<String, dynamic>> viewers) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Views", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            if (viewers.isEmpty) const Text("No views yet"),
            ...viewers.map((user) => ListTile(
              leading: CircleAvatar(
                backgroundImage: user['profile_url'] != null ? FileImage(File(user['profile_url'])) : null,
              ),
              title: Text(user['username'] ?? "Unknown User"),
              subtitle: Text("Viewed at: ${user['views_time'].toString().substring(11, 16)}"),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReactBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white54),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Send message...",
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        const Icon(Icons.favorite_border, color: Colors.white, size: 30),
        const SizedBox(width: 15),
        const Icon(Icons.send, color: Colors.white, size: 30),
      ],
    );
  }
}