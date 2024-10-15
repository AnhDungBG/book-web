import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_web_fe/blocs/auth/auth_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_event.dart';
import 'package:flutter_web_fe/blocs/auth/auth_state.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool _showForgotPassword = false;
  final GlobalKey<FormBuilderState> _loginFormKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _forgotPasswordFormKey =
      GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return FormBuilder(
              child: Center(
            child: Stack(
              children: [
                Opacity(
                  opacity: state is AuthLoading ? 0.3 : 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: CustomColor.primaryBlue,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 1000, maxHeight: 1000),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    'assets/images/banner_login.png',
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 3,
                            child: Padding(
                                padding: const EdgeInsets.all(80),
                                child: _showForgotPassword
                                    ? _buildForgotPasswordForm()
                                    : _buildLoginForm()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state is AuthLoading)
                  const Positioned(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColor.primaryRed),
                      ),
                    ),
                  ),
              ],
            ),
          ));
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return FormBuilder(
          key: _loginFormKey,
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: CustomColor.secondBlue,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (state is AuthFailure)
                Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.priority_high),
                        Text(
                          '${state.error}. Please try again',
                          style: const TextStyle(
                            color: CustomColor.primaryRed,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )),
              const SizedBox(height: 50),
              FormBuilderTextField(
                name: 'username',
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'username',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Icon(Icons.person),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return CustomColor.secondBlue;
                    } else {
                      return Colors.grey.shade600;
                    }
                  }),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: CustomColor.primaryBlue,
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: 'password',
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Icon(Icons.lock),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return CustomColor.secondBlue;
                    } else {
                      return Colors.grey.shade600;
                    }
                  }),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: CustomColor.primaryBlue,
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  suffixIcon: IconButton(
                    color: Colors.grey.shade400,
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                obscureText: _isObscure,
                keyboardType: TextInputType.text,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Don't have an account ?",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Beamer.of(context).beamToNamed('/register');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: CustomColor.secondBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showForgotPassword = true;
                        });
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        if (_loginFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _loginFormKey.currentState?.value;
                          BlocProvider.of<AuthBloc>(context).add(
                            LoginEvent(
                              formData?['username'],
                              formData?['password'],
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 37, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: const SizedBox(
                  width: 100,
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColor.secondBlue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
    });
  }

  Widget _buildForgotPasswordForm() {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return FormBuilder(
          key: _forgotPasswordFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                ),
                const Text(
                  'Forgot password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Enter your username account'),
                const SizedBox(
                  height: 50,
                ),
                FormBuilderTextField(
                  name: 'username',
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'username',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Icon(Icons.person),
                    ),
                    prefixIconColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.focused)) {
                        return CustomColor.secondBlue;
                      } else {
                        return Colors.grey.shade600;
                      }
                    }),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(
                        color: CustomColor.primaryBlue,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.username(),
                  ]),
                ),
                const SizedBox(
                  height: 25,
                ),
                MouseRegion(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: CustomColor.primaryBlue,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 150, vertical: 10),
                    ),
                    child: const Text('Next'),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showForgotPassword = false;
                      });
                    },
                    child: const Text(
                      'Switch back to login',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
