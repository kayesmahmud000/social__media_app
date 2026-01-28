import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/screens/home_page.dart';
import 'package:social_media_app/screens/login_page.dart';
import 'package:social_media_app/widgets/logo.dart';
import 'package:social_media_app/widgets/ui_helper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void handleSignup() async {
    final email = emailController.text;
    final pass = passController.text;
    final userName = nameController.text;

    if (email.isEmpty || pass.isEmpty || userName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fill the All Input")));
      return;
    }

    bool isSuccess = await context.read<AuthProvider>().signUp(
      userName,
      email,
      pass,
    );

    if (isSuccess) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to Sign in")));
      }
    }
  }

  // TODO: Copywith constractor
  // TODO: error handling
  // TODO: from validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
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
              const SizedBox(height: 10),

              UiHelper.customTextField(
                controller: nameController,
                text: "Username",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),

              UiHelper.customBtn(
                callback: () {
                  handleSignup();
                },
                text: "Sign Up",
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: .center,
                mainAxisSize: .min,
                children: [
                  Text(
                    "Already Have an Account ? ",
                    style: TextStyle(fontSize: 15, fontWeight: .w500),
                  ),
                  UiHelper.customTextBtn(
                    callback: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    text: "Log In ",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
