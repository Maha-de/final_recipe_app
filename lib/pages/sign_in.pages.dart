import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/forget_password.pages.dart';
import 'package:recipe_app/pages/homepage.pages.dart';
import 'package:recipe_app/pages/register.pages.dart';
import 'package:recipe_app/provider/app_auth.provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    Provider.of<AppAuthProvider>(context, listen: false).providerInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppAuthProvider>( builder: (context, authProvider, _) =>
          Form(
            key: authProvider.formKey,
            child: Stack(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/background.png"),
                              fit: BoxFit.cover)
                      )),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 10, 20),
                    child: Container(
                      height: 250, width: 250,
                      decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/logo3.png",),)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 160, 10, 20),
                    child: Center(
                      child: ListView(
                        children: [
                          const SizedBox(height: 50),
                          const Center(
                              child: Text("Sign In", style: TextStyle(fontSize: 20,
                                  color: Colors.white, fontWeight: FontWeight.bold),)),
                          const SizedBox(height: 40,),
                          TextFormField(
                            controller: authProvider.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                                labelText: "Email Address",
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(borderSide:
                                BorderSide(color: Colors.white))
                            ),
                            style: const TextStyle(fontSize: 15, color: Colors.white),

                          ),
                          const SizedBox(height: 20,),
                          TextFormField(
                              controller: authProvider.passwordController,
                              obscureText: authProvider.obSecureText,
                              decoration: InputDecoration(
                                  errorStyle: const TextStyle(color: Colors.red),
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                                  suffixIcon: InkWell(onTap: () => authProvider.toggleObSecure(),
                                    child: Icon(color: Colors.white,
                                        authProvider.obSecureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                  ),
                                  labelText: "Password",
                                  labelStyle: const TextStyle(color: Colors.white),
                                  enabledBorder: const UnderlineInputBorder(borderSide:
                                  BorderSide(color: Colors.white))
                              ),
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'password is required';
                                }
                                if (value.length < 6) {
                                  return 'password too short';
                                }
                                return null;
                              }
                          ),
                          Row(
                            // padding: const EdgeInsets.fromLTRB(210, 10, 0, 20),
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                  TextButton(onPressed: (){
                                     Navigator.push(context,
                                    MaterialPageRoute(builder: (_) =>
                                    const ForgetPasswordPage()));
                                                              }, child:
                                      const Text("Forgot Password?", textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.blue))),
                                ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 40, 20),
                            child: ElevatedButton (onPressed: ()  {
                              authProvider.signIn(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>
                                      const HomePage()));
                              // }
                            }, child: const Text("Sign In", style: TextStyle(fontSize: 18, color: Colors.white),),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(80, 60, 40, 10),
                            child: Row(children: [
                              const Text("Don't have an account? ", style: TextStyle(color: Colors.white,),
                                textAlign: TextAlign.center,),
                              TextButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                              },
                                  child: const Text("Register", style: TextStyle(color: Colors.deepOrange)))
                            ],),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
      ),
    );
  }
}
