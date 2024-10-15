import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_event.dart';
import 'package:flutter_web_fe/blocs/auth/auth_state.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class EmailVerificationPage extends StatefulWidget {
  final Function(String) onEmailVerified;

  const EmailVerificationPage({super.key, required this.onEmailVerified});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is EmailVerificationSent) {
          setState(() {
            _isOtpSent = true;
            _errorMessage = null;
            _successMessage = state.message;
          });
        } else if (state is AuthFailure) {
          setState(() {
            _errorMessage = state.error;
            _successMessage = null;
          });
        } else if (state is OtpVerified) {
          widget.onEmailVerified(_emailController.text);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(50.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_successMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _successMessage!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (!_isOtpSent)
                  ElevatedButton(
                    onPressed: state is AuthLoading ? null : _sendOtp,
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Gửi mã OTP',
                            style: TextStyle(color: CustomColor.neutralGray),
                          ),
                  ),
                if (_isOtpSent) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _otpController,
                    decoration: const InputDecoration(labelText: 'Mã OTP'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mã OTP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: state is AuthLoading ? null : _verifyOtp,
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : const Text('Xác thực OTP'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(VerifyEmailEvent(_emailController.text));
    }
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      context
          .read<AuthBloc>()
          .add(VerifyOtpEvent(_emailController.text, _otpController.text));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
