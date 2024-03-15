//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:programovil/screens/dashboard_screen.dart';
//import 'package:programovil/screens/dashboard_screen.dart';
import 'package:programovil/screens/register_screen.dart';
import 'package:programovil/services/email_auth_firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final auth = EmailAuthFirebase();
  final email = TextEditingController();
  final pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final pwdUser = TextFormField(
      controller: pwd,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('images/fondo.jpeg'))),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 470,
                child: Opacity(
                  opacity: .5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    height: 155,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        txtUser,
                        const SizedBox(
                          height: 10,
                        ),
                        pwdUser
                      ],
                    ),
                  ),
                ),
              ),
              Image.asset('images/logo_text.png'),
              Positioned(
                  bottom: 50,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SignInButton(Buttons.Email, onPressed: () {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          auth
                              .signInUser(password: pwd.text, email: email.text)
                              .then((value) {
                            if (!value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('El Usuario no es valido'),
                                ),
                              );
                            } else {
                              Navigator.pushNamed(context, "/dash")
                                  .then((value) {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                              });
                            }
                          });

                          /*Future.delayed(new Duration(milliseconds: 5000), () {
                            /*Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => new DashboardScreen(),)
                              );*/
                            Navigator.pushNamed(context, "/dash").then((value) {
                              setState(() {
                                isLoading = !isLoading;
                              });
                            });
                          });*/
                        }),
                        SignInButton(Buttons.Google, onPressed: () {}),
                        SignInButton(Buttons.Facebook, onPressed: () {}),
                        //SignInButton(Buttons.GitHub, onPressed: () {}),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          },
                          child: Container(
                            height: 35,
                            width: 320,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                            ),
                            child: const Center(
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              isLoading
                  ? const Positioned(
                      top: 260,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
