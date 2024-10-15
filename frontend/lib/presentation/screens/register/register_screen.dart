import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_event.dart';
import 'package:flutter_web_fe/blocs/auth/auth_state.dart';
import 'package:flutter_web_fe/presentation/screens/register/confirm.dart';
import 'package:flutter_web_fe/presentation/screens/register/user_info.dart';
import 'package:flutter_web_fe/presentation/screens/register/verify_email.dart';
import 'package:flutter_web_fe/presentation/screens/login/login_screen.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  String _email = '';
  Map<String, String> _userInfo = {};
  int _currentStep = 0;

  final List<String> _steps = [
    'Xác thực Email',
    'Thông tin cá nhân',
    'Xác nhận'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified) {
            _nextStep();
          } else if (state is RegisterSuccess) {
            Beamer.of(context).beamToNamed('/');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showLoginDialog(context);
            });
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: CustomColor.primaryBlue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/images/banner_image_lagre.png',
                      //     width: double.infinity),
                      const SizedBox(height: 30),
                      ..._buildStepIndicators(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đăng ký tài khoản',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: CustomColor.secondBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Beamer.of(context).beamToNamed('/');
                        },
                        child: const SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: CustomColor.coolGray,
                                ),
                                Text(
                                  'Quay về trang chủ',
                                  style: TextStyle(
                                    color: CustomColor.coolGray,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Center(
                        child: Text(
                          _steps[_currentStep],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            EmailVerificationPage(
                              onEmailVerified: (email) {
                                setState(() {
                                  _email = email;
                                });
                              },
                            ),
                            UserInfoPage(
                              onInfoSubmitted: (userInfo) {
                                setState(() {
                                  _userInfo = userInfo;
                                });
                                _nextStep();
                              },
                            ),
                            ConfirmationPage(
                              email: _email,
                              userInfo: _userInfo,
                              onRegister: _register,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildStepIndicators() {
    return List.generate(_steps.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentStep >= index
                    ? CustomColor.coolGray
                    : Colors.white54,
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                    color: _currentStep >= index
                        ? CustomColor.primaryBlue
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _steps[index],
              style: TextStyle(
                color: _currentStep >= index
                    ? CustomColor.neutralGray
                    : Colors.white70,
                fontWeight:
                    _currentStep >= index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    });
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < _steps.length - 1) {
        _currentStep++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _register() {
    context.read<AuthBloc>().add(RegisterEvent(
          email: _email,
          password: _userInfo['password']!,
          username: _userInfo['username']!,
          hoten: _userInfo['hoten']!,
          gioitinh: _userInfo['gioitinh']!,
          diachi: _userInfo['diachi']!,
          dienthoai: _userInfo['dienthoai']!,
          ngaysinh: _userInfo['ngaysinh']!,
          cmnd: _userInfo['cmnd']!,
        ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
