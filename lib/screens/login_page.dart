import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/logo.dart';
import 'package:social_media_app/widgets/ui_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Logo.logo(),
              SizedBox(height: 15),
              UiHelper.customTextField(
                controller: emailController,
                text: "Email",
                textInputType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 10),

              UiHelper.customTextField(
                controller: passController,
                text: "Password",
                textInputType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 10),

              UiHelper.customBtn(callback: () {}, text: "Login"),
            ],
          ),
        ),
      ),
    );
  }
}
