import 'package:app/controller/allController.dart';
import 'package:app/presentation/login/signin.dart';
import 'package:app/presentation/main_page.dart';
import 'package:app/presentation/widgets/constance.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/appicon.png', height: 100),
            h20,
            Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.teal,
                ),
                image: const DecorationImage(
                  image: AssetImage('asset/animaate.gif'),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> gotoLogin() async {
    final provider = context.read<AuthNotifier>();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (provider.currentUser != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, MainPage.mainrt);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, LoginScreen.loginRt);
    }
  }
}
