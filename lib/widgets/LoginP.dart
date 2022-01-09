// ignore_for_file: file_names

import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'auth.dart';
import 'game/page.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    Widget component1(IconData icon, String hintText, bool isPassword,
        bool isEmail, TextEditingController controller) {
      Size size = MediaQuery.of(context).size;
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 15,
            sigmaX: 15,
          ),
          child: Container(
            height: size.height / 8,
            width: size.width / 1.2,
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: size.width / 30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white.withOpacity(.8)),
              cursorColor: Colors.white,
              obscureText: isPassword,
              keyboardType:
                  isEmail ? TextInputType.emailAddress : TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  color: Colors.white.withOpacity(.7),
                ),
                border: InputBorder.none,
                hintMaxLines: 1,
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(.5)),
              ),
            ),
          ),
        ),
      );
    }

    Widget component2(String string, double width, VoidCallback voidCallback) {
      Size size = MediaQuery.of(context).size;
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: voidCallback,
            child: Container(
              height: size.height / 8,
              width: size.width / width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                string,
                style: TextStyle(color: Colors.white.withOpacity(.8)),
              ),
            ),
          ),
        ),
      );
    }

    final username = TextEditingController();
    final emailcontroller = TextEditingController();

    final passwordcontroller = TextEditingController();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * .1),
                    child: Text(
                      'PUZZZI',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.7),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        wordSpacing: 4,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      component1(Icons.account_circle_outlined, 'User name...',
                          false, false, username),
                      component1(Icons.email_outlined, 'Email...', false, true,
                          emailcontroller),
                      component1(Icons.lock_outline, 'Password...', true, false,
                          passwordcontroller),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          component2(
                            'LOGIN',
                            2.58,
                            () async {
                              HapticFeedback.lightImpact();
                              //  setState(() {
                              isloading = true;
                              // });
                              UserCredential? user = await AuthService().signup(
                                  email: emailcontroller.text,
                                  password: passwordcontroller.text,
                                  username: username.text);

                              if (user != null) {
                                // setState(() {
                                isloading = false;
                                // });
                                log(user.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const GamePage()));
                              }
                              if (user == null) {
                                // setState(() {
                                isloading = false;
                                // });
                                log("Error");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content:  Text("Error")));
                              }
                            },
                          ),
                          SizedBox(width: size.width / 20),
                          component2(
                            'Forgotten password!',
                            2.58,
                            () {
                              HapticFeedback.lightImpact();
                              Fluttertoast.showToast(
                                  msg: 'Forgotten password button pressed');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      component2(
                        'Have An Account Already? Login',
                        2,
                        () {
                          HapticFeedback.lightImpact();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const Login()));
                        },
                      ),
                      SizedBox(height: size.height * .05),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
