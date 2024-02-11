import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/utilities/edges.dart';
import 'package:recipe_app/utilities/toast_message_status.dart';
import 'package:recipe_app/widgets/toast_message.widgets.dart';

import '../provider/app_auth.provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {

  final emailController = TextEditingController();
  //
  //
  // Future resetPassword() async {
  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
  //     // Password reset email sent successfully
  //     print("Password reset email sent successfully");
  //   } catch (e) {
  //     // Error occurred. Handle error.
  //     print("Error sending password reset email: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>( builder: (context, authProvider, _) =>
      Scaffold(
      appBar: AppBar(
        title: Text("Forget Password")
      ),
      body: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: Edges.appHorizontalPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // UI for the "forgot password" feature
              TextFormField(
                controller: authProvider.emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                // validator: (value) {
                //   if (value!.isEmpty || !value!.contains('@')) {
                //     return 'Invalid email!';
                //   }
                //   return null;
                // },
                // onSaved: (value) {
                //   var _email = value?.trim();
                // },
              ),

              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: authProvider.emailController!.text);
                    // Password reset email sent successfully
                    print("Password reset email sent successfully");
                    showDialog(
                      useSafeArea: true,
                        barrierDismissible: true,
                        context: context, builder: (context) =>
                        AlertDialog(
                          title: Text('Success'),
                          content: Text('Reset Email sent successfully',
                            // style: TextStyle(fontSize: 20),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Close'),
                            ),
                          ],
                        )
                    //     Text("Rest Email sent successfully",
                    // style: TextStyle(color: (Colors.black)),)

                    );
                  } catch (e) {
                    // Error occurred. Handle error.
                    print("Error sending password reset email: $e+$emailController");
                  }
                // resetPassword("");
              }, child: Text('Send Reset Email', style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,)




              )],
          ),
        ),
      ),
    ));
  }
}
