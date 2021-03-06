import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
            controller: emailcontroller,
            decoration: const InputDecoration(
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
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            controller: passwordcontroller,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            onEditingComplete: () => TextInput.finishAutofillContext(),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
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
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          setState(() {
            isloading = true;
          });
          dynamic user = await AuthService().login(
              email: emailcontroller.text, password: passwordcontroller.text);

          if (user is UserCredential) {
            if (user.user != null) {
              setState(() {
                isloading = false;
              });
              log(user.toString());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GamePage(islogged: true)));
            }
          }
          if (user is! UserCredential) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Error: " +
                    user
                        .toString()
                        .substring(120, user.toString().length - 1))));
            log("Error");
            setState(() {
              isloading = false;
            });
          }
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            '',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 1.6),
          ),
          SizedBox.fromSize(
            size: const Size.square(70.0), // button width and height
            child: ClipOval(
              child: Material(
                color: const Color.fromRGBO(76, 81, 93, 1),
                child: isloading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.arrow_forward,
                        color: Colors.white), // button color
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpPage())),
            child: const Text(
              'Register',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2),
            ),
          ),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              if (emailcontroller.text.isNotEmpty) {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailcontroller.text)
                    .whenComplete(() {
                  Fluttertoast.showToast(
                      msg: "Check your email for Resetting instructions");
                });
              } else {
                Fluttertoast.showToast(msg: "Enter Email Address");
              }
            },
            child: const Text(
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
                child: const SigninContainer()),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          SizedBox(height: height * .55),
                          _usernameWidget(),
                          const SizedBox(height: 20),
                          _passwordWidget(),
                          const SizedBox(height: 30),
                          _submitButton(),
                          SizedBox(height: height * .050),
                          _createAccountLabel(),
                        ],
                      ),
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
