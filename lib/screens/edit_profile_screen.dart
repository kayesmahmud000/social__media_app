import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/helper/image_pick_helper.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/usecases/user_update_use_case.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;

  final ImagePickHelper _imageHelper = ImagePickHelper();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _usernameController = TextEditingController(text: user?.userName ?? "");
  }

  @override
  void dispose() {
    _usernameController.dispose();

    super.dispose();
  }

  void _handleImagePick() async {
    String? path = await _imageHelper.picAndSaveImage();
    if (path != null) {
      setState(() => _selectedImagePath = path);
    }
  }

  void handleUpdate(AuthProvider authProvider) async {
    final user = authProvider.currentUser;
    if (user == null) return;

    final updateDTO = UserUpdateDTO(
      id: user.id!,
      username: _usernameController.text.trim(),
      profileUrl: _selectedImagePath ?? user.profileUrl ?? "",
    );

    bool success = await authProvider.updateUser(updateDTO);
    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: authProvider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check, color: Colors.blue, size: 30),
            onPressed: authProvider.isLoading
                ? null
                : () => handleUpdate(authProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedImagePath != null
                        ? FileImage(File(_selectedImagePath!))
                        : (user?.profileUrl != null &&
                                      user!.profileUrl!.isNotEmpty
                                  ? FileImage(File(user.profileUrl!))
                                  : null)
                              as ImageProvider?,
                    child:
                        (user?.profileUrl == null && _selectedImagePath == null)
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  TextButton(
                    onPressed: _handleImagePick,
                    child: const Text(
                      'Edit picture',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Divider(),

            _buildEditField(label: "Username", controller: _usernameController),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Personal information settings",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
