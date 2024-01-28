import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/pages/homepage.pages.dart';
import 'package:recipe_app/pages/sign_in.pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    initSplash();
    super.initState();
  }

  void initSplash() async {

    await Future.delayed(const Duration(seconds: 3));
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if(user == null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d0e0e),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover)
        ),
        child: Center(
          child: Image.asset("assets/images/logo3.png"),
        ),
      ),
    );
  }
}
