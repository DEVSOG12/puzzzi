import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzzi/widgets/auth.dart';

import 'package:puzzzi/widgets/constants.dart';
import 'package:puzzzi/widgets/game/page.dart';
import 'package:puzzzi/widgets/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    bool isloading = false;
    Size size = MediaQuery.of(context).size;
    final namecontoller = TextEditingController();
    final emailcontroller = TextEditingController();
    final passwordcontroller = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(size.height > 770
          ? 64
          : size.height > 670
              ? 32
              : 16),
      child: Center(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: size.height *
                (size.height > 770
                    ? 0.7
                    : size.height > 670
                        ? 0.8
                        : 0.9),
            width: 500,
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 30,
                      child: Divider(
                        color: kPrimaryColor,
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    TextField(
                      controller: namecontoller,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        labelText: 'Name',
                        suffixIcon: Icon(
                          Icons.person_outline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    TextField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        suffixIcon: Icon(
                          Icons.mail_outline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        suffixIcon: Icon(
                          Icons.lock_outline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 64,
                    ),
                    InkWell(
                      child: isloading
                          ? Center(child: CircularProgressIndicator())
                          : actionButton("Create Account"),
                      onTap: () async {
                        setState(() {
                          isloading = true;
                        });
                        UserCredential?   user = await AuthService().signup(
                            email: emailcontroller.text,
                            password: passwordcontroller.text,
                            username: namecontoller.text);

                        if (user != null) {
                          setState(() {
                            isloading = false;
                          });
                          log(user.toString());
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => GamePage()));
                        }
                        if (user == null) {
                          setState(() {
                            isloading = false;
                          });
                          log("Error");
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Error")));
                        }
                      },
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => LogIn()));
                          },
                          child: isloading
                              ? Center(child: CircularProgressIndicator())
                              : Row(
                                  children: [
                                    Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
