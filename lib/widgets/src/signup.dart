import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzzi/widgets/auth.dart';
import 'package:puzzzi/widgets/game/material/victory.dart';
import 'package:puzzzi/widgets/game/page.dart';
import 'package:puzzzi/widgets/src/Widget/signupContainer.dart';
import 'package:puzzzi/widgets/src/signin.dart';

class SignUpPage extends StatefulWidget {
  final Function? function;
  const SignUpPage({Key? key, this.function}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isloading = false;
  final username = TextEditingController();
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 20, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameWidget() {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            controller: username,
            decoration: const InputDecoration(
              // hintText: 'Enter your full name',
              labelText: 'Username',
              labelStyle: TextStyle(
                  color: Color.fromRGBO(226, 222, 211, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
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

  Widget _emailWidget() {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            controller: emailcontroller,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              // hintText: 'Enter your full name',
              labelText: 'Email',
              labelStyle: TextStyle(
                  color: Color.fromRGBO(226, 222, 211, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
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

  Widget _passwordWidget() {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            controller: passwordcontroller,
            obscureText: true,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                  color: Color.fromRGBO(226, 222, 211, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
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

  // String getMessageFromErrorCode(error) {
  //   switch (error) {
  //     case "ERROR_EMAIL_ALREADY_IN_USE":
  //     case "account-exists-with-different-credential":
  //     case "email-already-in-use":
  //       return "Email already used. Go to login page.";
  //       break;
  //     case "ERROR_WRONG_PASSWORD":
  //     case "wrong-password":
  //       return "Wrong email/password combination.";
  //       break;
  //     case "ERROR_USER_NOT_FOUND":
  //     case "user-not-found":
  //       return "No user found with this email.";
  //       break;
  //     case "ERROR_USER_DISABLED":
  //     case "user-disabled":
  //       return "User disabled.";
  //       break;
  //     case "ERROR_TOO_MANY_REQUESTS":
  //     case "operation-not-allowed":
  //       return "Too many requests to log into this account.";
  //       break;
  //     case "ERROR_OPERATION_NOT_ALLOWED":
  //     case "operation-not-allowed":
  //       return "Server error, please try again later.";
  //       break;
  //     case "ERROR_INVALID_EMAIL":
  //     case "invalid-email":
  //       return "Email address is invalid.";
  //       break;
  //     default:
  //       return "Login failed. Please try again.";
  //       break;
  //   }
  // }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          setState(() {
            isloading = true;
          });
          bool? can =
              await AuthService().isuseravailable(username: username.text);
          if (can!) {
            dynamic user = await AuthService().signup(
                email: emailcontroller.text,
                password: passwordcontroller.text,
                username: username.text);

            if (user is UserCredential) {
              if ((user).user != null) {
                setState(() {
                  isloading = false;
                });

                log(user.toString());
                if (widget.function != null) {
                  widget.function;
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GamePage(islogged: true)));
              }
            }
            if (user! is! UserCredential) {
              setState(() {
                isloading = false;
              });
              // log("Error : ${getMessageFromErrorCode(user)}");
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error:  ${user.toString()}")));
            }
          } else {
            setState(() {
              isloading = false;
            });

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Username Taken")));
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

  Widget _createLoginLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignInPage())),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationThickness: 2,
          ),
        ),
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
                child: const SignUpContainer()),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: height * .4),
                        _nameWidget(),
                        const SizedBox(height: 20),
                        _emailWidget(),
                        const SizedBox(height: 20),
                        _passwordWidget(),
                        const SizedBox(height: 80),
                        _submitButton(),
                        SizedBox(height: height * .050),
                        _createLoginLabel(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(top: 60, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
