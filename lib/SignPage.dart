import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:strokepred/homepage.dart';
// import 'package:strokepred/StrokePage.dart';

import 'SelectPage.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);
  static String id='sign-up';


  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key= GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    //User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset("assets/health.png",
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.5),
                colorBlendMode: BlendMode.lighten,
              ),
              Center(
                child: Form(
                  key: _key,
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("STROKE PREDICTOR",
                          textAlign: TextAlign.center,
                          style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 50,),),
                        Padding(padding: const EdgeInsets.all(20)),
                        TextFormField(
                          controller: emailController,
                          validator: validateEmail,
                          decoration: InputDecoration(
                              labelText: "Email",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight. bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: validatePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Password",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight. bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Center(
                            child: Text(errorMessage, style: TextStyle(color: Colors.red),),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                child: isLoading? CircularProgressIndicator(color: Colors.white,)
                            :Text("SIGN UP"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black,),
                                onPressed: () async{
                               setState(() {
                                 isLoading = true;
                                 errorMessage = '';
                               });
                                  if(_key.currentState!.validate()) {
                                    try {
                                     final new_user=  await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                     if (new_user != null) {
                                       Navigator.pushNamed(context, Selectpage.id);
                                     }

                                    } on FirebaseAuthException catch(error) {
                                      errorMessage = error.message!;
                                    }
                                    setState(() => isLoading = false);
                                  }
                                }),
                            ElevatedButton(child:
                            isLoading? CircularProgressIndicator(color: Colors.white,)
                            : Text("SIGN IN"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black,),
                                onPressed: () async{
                                  setState(() => isLoading = true);

                                  if(_key.currentState!.validate()) {
                                    try {
                                      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                      if (user != null) {
                                        Navigator.pushNamed(context, Selectpage.id);}
                                      errorMessage = '';
                                    } on FirebaseAuthException catch (error) {
                                      errorMessage = error.message!;
                                    }
                                    setState(() => isLoading = false);
                                  }
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]
        )
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'Email address is required';

  String pattern= r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if(!regex.hasMatch(formEmail)) return 'Invalid Email Address Format';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty)
    return 'Password is required';

  String pattern= r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if(!regex.hasMatch(formPassword))
    return '''
    Password must be at least 8 characters ,
    include an uppercase letter, number and symbol
    ''';

  return null;
}