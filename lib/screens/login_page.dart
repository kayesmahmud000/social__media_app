import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/auth_provider.dart';
import 'package:social_media_app/screens/bottom_nav_screen.dart';
import 'package:social_media_app/screens/home_page.dart';
import 'package:social_media_app/screens/signup_page.dart';
import 'package:social_media_app/usecases/user_login_use_case.dart';
import 'package:social_media_app/widgets/logo.dart';
import 'package:social_media_app/widgets/ui_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey =GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final pass = passController.text;
    

      try {
        var userDTO = UserLoginDTO(
          email: email,
          password: pass,
        );

        bool isSuccess = await context.read<AuthProvider>().login(userDTO);

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
  Widget build(BuildContext context) {
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
          
                UiHelper.customBtn(
                  callback: () {
                    handleLogin();
                  },
                  text: "Login",
                ),
          
                const SizedBox(height: 15),
          
                Row(
                  mainAxisAlignment: .center,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      "Don't Have an Account ? ",
                      style: TextStyle(fontSize: 15, fontWeight: .w500),
                    ),
                    UiHelper.customTextBtn(
                      callback: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      text: "Create Account",
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
