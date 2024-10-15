import 'package:flutter/material.dart';
import 'package:flutter_web_fe/presentation/screens/login/components/login_form.dart';

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: const SizedBox(
          width: 1000,
          height: 600,
          child: LoginForm(),
        ),
      );
    },
  );
}
