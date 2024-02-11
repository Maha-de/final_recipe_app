import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/sign_in.pages.dart';
import 'package:recipe_app/provider/app_auth.provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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
                          const SizedBox(height: 50,),
                          const Center(
                              child: Text("Register", style: TextStyle(fontSize: 20, color: Colors.white,
                                  fontWeight: FontWeight.bold),)),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: authProvider.nameController,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                              labelText: "Full Name",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),                  ),
                            style: const TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          const SizedBox(height: 20,),
                          TextFormField(
                            controller: authProvider.emailController,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                              labelText: "Email Address",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
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
                                  suffixIcon:
                                  // authProvider.obSecureText ?
                                  //     Icon(Icons.visibility_off)
                                  // : Icon(Icons.visibility),
                                  InkWell(onTap: () => authProvider.toggleObSecure(),
                                    child: Icon(color: Colors.white,
                                        authProvider.obSecureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                  ),

                                  labelText: "Password",
                                  labelStyle: const TextStyle(color: Colors.white),
                                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))                  ),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 50, 40, 20),
                            child: ElevatedButton(onPressed: (){
                              authProvider.signUp(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()));

                            },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text("Register", style: TextStyle(fontSize: 18, color: Colors.white),)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(80, 80, 40, 10),
                            child: Row(children: [
                              const Text("Already registered? ", style: TextStyle(color: Colors.white,),
                                textAlign: TextAlign.center,),
                              TextButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));

                              },
                                  child: const Text("Sign in", style: TextStyle(color: Colors.deepOrange)))
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
