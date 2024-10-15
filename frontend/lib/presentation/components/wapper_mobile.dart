import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/core/constants/nav_items.dart';
import 'package:flutter_web_fe/blocs/auth/auth_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_state.dart';
import 'package:flutter_web_fe/presentation/routes/router.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          final isLogin = state is Authenticated;
          final user = isLogin ? state.user : null;
          return ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (user != null)
                      GestureDetector(
                        onTap: () {
                          Beamer.of(context).beamToNamed('/profile');
                        },
                        child: CircleAvatar(
                          backgroundImage: user.avatarUrl!.isNotEmpty
                              ? NetworkImage(user.avatarUrl!)
                              : const AssetImage(
                                  'assets/images/default_avatar.png'),
                        ),
                      )
                    // Image(image: )
                  ],
                ),
              ),
              for (int i = 0; i < navTitle(context).length; i++)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  titleTextStyle: const TextStyle(fontWeight: FontWeight.w600),
                  leading: Icon(navIcon(context)[i]),
                  title: Text(navTitle(context)[i]),
                  onTap: () {
                    handleNavigation(context, navTitle(context)[i]);
                  },
                )
            ],
          );
        }));
  }
}
