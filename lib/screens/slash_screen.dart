import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_media_app/screens/login_page.dart';
import 'package:social_media_app/widgets/logo.dart';
import 'package:social_media_app/widgets/ui_helper.dart';

class SlashScreen extends StatefulWidget {
  const SlashScreen({super.key});

  @override
  State<SlashScreen> createState() => _SlashScreenState();
}

class _SlashScreenState extends State<SlashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Logo.logo()));
  }
}
