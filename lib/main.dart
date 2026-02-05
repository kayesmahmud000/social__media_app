import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/providers/comment_provider.dart';
import 'package:social_media_app/providers/post_provider.dart';
import 'package:social_media_app/providers/stroy_provider.dart';
import 'package:social_media_app/screens/slash_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create:(context) => AuthProvider(), ),
    ChangeNotifierProvider(create:(context) => PostProvider(),),
    ChangeNotifierProvider(create:(context) => CommentProvider(),),
    ChangeNotifierProvider(create:(context) => StroyProvider(),)
  ],
  child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: SlashScreen(),
    );
  }
}
