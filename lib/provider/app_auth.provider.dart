import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:recipe_app/pages/homepage.pages.dart';
import 'package:recipe_app/pages/register.pages.dart';
import '../pages/sign_in.pages.dart';

class AppAuthProvider extends ChangeNotifier {
  GlobalKey<FormState>? formKey;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? nameController;
  bool obSecureText = true;

  void providerInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  void providerDispose() {
    emailController = null;
    passwordController = null;
    nameController = null;
    formKey = null;
    obSecureText = true;
  }

  void toggleObSecure() {
    obSecureText = !obSecureText;
    notifyListeners();
  }

  void openRegisterPage(BuildContext context) {
    providerDispose();
    Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
  }

  void openLoginPage(BuildContext context) {
    providerDispose();
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  Future<void> signUp(BuildContext context) async {
    try {
      if (formKey?.currentState?.validate() ?? false) {
        var credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController!.text,
            password: passwordController!.text);

        if (credentials.user != null) {
          await credentials.user?.updateDisplayName(nameController!.text);
          // FirebaseAuth.instance.currentUser.updatePhotoURL(photoURL);
          providerDispose();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        }
      }
    } catch (e) {
      print("Error in SignUp");
    }
  }

  Future<void> signIn(BuildContext context) async {
    try {
      if (formKey?.currentState?.validate() ?? false) {
        var credentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController!.text,
            password: passwordController!.text);

        if (credentials.user != null) {
          await credentials.user?.updateDisplayName(emailController!.text);
          providerDispose();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        }
      }
    } catch (e) {
      print("Error in Login");
    }
  }


  void signOut(BuildContext context) async {
    OverlayLoadingProgress.start();
    await Future.delayed(const Duration(seconds: 1));
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
    }
    OverlayLoadingProgress.stop();
  }
}