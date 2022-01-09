import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzzi/widgets/auth.dart';
import 'package:puzzzi/widgets/game/page.dart';
import 'package:puzzzi/widgets/src/Widget/singinContainer.dart';
import 'package:puzzzi/widgets/src/signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isloading = false;
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  Widget _usernameWidget() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: emailcontroller,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                  color: Color.fromRGBO(226, 222, 211, 1),
                  fontWeight: FontWeight.bold),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(226, 222, 211, 1)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
        child: InkWell(
          highlightColor: Colors.greenAccent,
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

  Widget _passwordWidget() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            controller: passwordcontroller,
            obscureText: true,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                  color: Color.fromRGBO(226, 222, 211, 1),
                  fontWeight: FontWeight.bold),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(226, 222, 211, 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return isloading
        ? CircularProgressIndicator()
        : component2(
            'LOGIN',
            2.58,
            () async {
              HapticFeedback.lightImpact();
              setState(() {
                isloading = true;
              });
              UserCredential? user = await AuthService().login(
                  email: emailcontroller.text,
                  password: passwordcontroller.text);

              if (user != null) {
                setState(() {
                  isloading = false;
                });
                log(user.toString());
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => GamePage()));
              }
              if (user == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Error")));
                log("Error");
              }
            },
          );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpPage())),
            child: Text(
              'Register',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2),
            ),
          ),
          InkWell(
            // onTap: () {
            //   // Navigator.push(
            //   //     context, MaterialPageRoute(builder: (context) => SignUpPage()));
            // },
            child: Text(
              'Forgot Password',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
                height: MediaQuery.of(context).size.height * 1,
                child: SigninContainer()),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: height * .55),
                        _usernameWidget(),
                        SizedBox(height: 20),
                        _passwordWidget(),
                        SizedBox(height: 30),
                        _submitButton(),
                        SizedBox(height: height * .050),
                        _createAccountLabel(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(top: 60, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
