import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/background.png"),
                              fit: BoxFit.cover)
                      )),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 10, 20),
                    child: Container(
                      height: 250, width: 250,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/logo3.png",),)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 160, 10, 20),
                    child: Center(
                      child: ListView(
                        children: [
                          SizedBox(height: 50),
                          Center(
                              child: Text("Sign In", style: TextStyle(fontSize: 20,
                                  color: Colors.white, fontWeight: FontWeight.bold),)),
                          SizedBox(height: 40,),
                          TextFormField(
                            controller: authProvider.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                                labelText: "Email Address",
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(borderSide:
                                BorderSide(color: Colors.white))
                            ),
                            style: TextStyle(fontSize: 15, color: Colors.white),

                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                              controller: authProvider.passwordController,
                              obscureText: authProvider.obSecureText,
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                                  suffixIcon: InkWell(onTap: () => authProvider.toggleObSecure(),
                                    child: Icon(color: Colors.white,
                                        authProvider.obSecureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                  ),
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(borderSide:
                                  BorderSide(color: Colors.white))
                              ),
                              style: TextStyle(fontSize: 15, color: Colors.white),
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
                            padding: const EdgeInsets.fromLTRB(210, 10, 0, 20),

                            child: TextButton(onPressed: (){

                            }, child:
                            Text("Forgot Password?", textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.blue))),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 40, 20),
                            child: ElevatedButton (onPressed: ()  {
                              authProvider.signIn(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>
                                      HomePage()));
                              // }
                            }, child: Text("Sign In", style: TextStyle(fontSize: 18, color: Colors.white),),
                              style: ElevatedButton.styleFrom(primary: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(80, 60, 40, 10),
                            child: Row(children: [
                              Text("Don't have an account? ", style: TextStyle(color: Colors.white,),
                                textAlign: TextAlign.center,),
                              TextButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                              },
                                  child: Text("Register", style: TextStyle(color: Colors.deepOrange)))
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
