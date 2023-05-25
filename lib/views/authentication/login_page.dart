import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/service/auth_service.dart';
import 'package:todo_app/shared/app_color.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/views/dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 50.0),
                ),
                const Text(
                  'Welcome back,\nplease login\nto your account',
                  style: TextStyle(fontSize: 30.0),
                ),
                ElevatedButton(
                  onPressed: _handleGoogleSignIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue with Google', style: TextStyle(fontSize: 16.0, color: AppColor.blackColor))
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      User? user = await AuthService.instance.signInWithGoogle();
      if (!mounted) return;
      Utils.showSnackBar(context, text: 'Logged in as ${user?.email}');
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const DashBoardPage()), (route) => false);
    } catch (e) {
      Utils.showSnackBar(context, text: e.toString());
    }
  }
}
