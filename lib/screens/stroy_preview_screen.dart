import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/providers/stroy_provider.dart';

import 'package:social_media_app/usecases/story_use_case.dart';

class StroyPreviewScreen extends StatefulWidget {
  final File imageFile; 
  const StroyPreviewScreen({super.key, required this.imageFile});

  @override
  State<StroyPreviewScreen> createState() => _StroyPreviewScreenState();
}

class _StroyPreviewScreenState extends State<StroyPreviewScreen> {
  bool _isUploading = false;

  Future<void> _postStory() async {
    setState(() => _isUploading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final storyProvider = context.read<StroyProvider>();
   

   
      final storyDTO = StoryDTO(
        userId: authProvider.currentUser!.id!,
        mediaUrl: widget.imageFile.path,
        timeStamp: DateTime.now().toIso8601String(),
        caption: "", 
      );

     
      await storyProvider.createStory(storyDTO);

     
      await storyProvider.getAllStories();

      if (mounted) {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Story posted successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to post story")),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Preview", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _isUploading
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _postStory,
                    child: const Text(
                      "Post Story",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}