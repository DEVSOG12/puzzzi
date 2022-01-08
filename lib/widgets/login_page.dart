import 'package:flutter/material.dart';
import 'desktop_mode.dart';
import 'mobile_mode.dart';

class LoginPage extends StatefulWidget {
  final bool issignup;
  LoginPage({required this.issignup});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 1024) {
          return MobileMode(
            issignup: widget.issignup,
          );
        } else {
          return DesktopMode(
            issignup: widget.issignup,
          );
        }
      },
    );
  }
}
