import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/widgets/logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider provider = context.watch<AuthProvider>();

    if (provider.currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(Icons.add, size: 36),
                ),
                Logo.logo(width: 110, bottom: -42, w: 100),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(Icons.search, size: 36),
                ),
              ],
            ),
            
          ),
        ],
      ),
    );
  }
}
