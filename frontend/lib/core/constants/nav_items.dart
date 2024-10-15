import 'package:flutter/material.dart';
import 'package:flutter_web_fe/blocs/auth/auth_bloc.dart';
import 'package:provider/provider.dart';

List<String> navTitle(BuildContext context) {
  Provider.of<AuthBloc>(context, listen: false);
  return [
    "Home",
    "Products",
    "About",
    "Contact",
  ];
}

List<IconData> navIcon(BuildContext context) {
  Provider.of<AuthBloc>(context);
  return [
    Icons.home,
    Icons.store,
    Icons.quick_contacts_mail,
    Icons.phone,
  ];
}
