import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/screens/bottom_nav_screen.dart';
import 'package:social_media_app/screens/home_page.dart';
import 'package:social_media_app/screens/login_page.dart';
import 'package:social_media_app/usecases/user_sign_up_usecase.dart';
import 'package:social_media_app/widgets/logo.dart';
import 'package:social_media_app/widgets/ui_helper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final pass = passController.text;
      final userName = nameController.text;

      try {
        var userDTO = UserSignUpDTO(
          username: userName,
          email: email,
          password: pass,
        );

        bool isSuccess = await context.read<AuthProvider>().signUp(userDTO);

        if (isSuccess && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please type valid email";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                UiHelper.customTextField(
                  controller: passController,
                  text: "Password",
                  textInputType: TextInputType.visiblePassword,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please type valid password";
                    }
                    if (value.length < 6) return "Password must be 6 Character";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),

                UiHelper.customTextField(
                  controller: nameController,
                  text: "Username",
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please type valid username";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),

                provider.isLoading
                    ? const CircularProgressIndicator()
                    : UiHelper.customBtn(
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
      ),
    );
  }
}
