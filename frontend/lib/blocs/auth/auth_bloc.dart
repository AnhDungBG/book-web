import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_event.dart';
import 'package:flutter_web_fe/blocs/auth/auth_state.dart';
import 'package:flutter_web_fe/core/data/models/auth_model.dart';
import 'package:flutter_web_fe/core/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  User? _currentUser;
  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_checkAuthStatus);
    on<GetUserInfoEvent>(_getUserInfo);
    on<RegisterEvent>(_onRegister);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }
  User? get currentUser => _currentUser;
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authService.login(event.username, event.password);
      if (res.containsKey('error')) {
        emit(AuthFailure(res['error']));
      } else {
        _currentUser = User.fromJson(res['user']);
        emit(Authenticated(_currentUser!));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      authService.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _checkAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    var res = await authService.checkAuthStatus();
    if (res != null && res.containsKey('error')) {
      emit(AuthFailure(res['error']));
    } else if (res != null && res.containsKey('user')) {
      User currentUser = User.fromJson(res['user']);
      emit(Authenticated(currentUser));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _getUserInfo(
      GetUserInfoEvent event, Emitter<AuthState> emit) async {
    var res = await authService.getUserInfo();

    if (res != null) {
      User currentUser = User.fromJson(res);
      emit(Authenticated(currentUser));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onVerifyEmail(
      VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authService.verifyEmail(event.email);
      if (res.containsKey('error')) {
        emit(AuthFailure(_decodeUtf8(res['error'])));
      } else {
        emit(EmailVerificationSent(message: res['message']));
      }
    } catch (e) {
      emit(AuthFailure(_decodeUtf8(e.toString())));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authService.verifyOtp(event.email, event.otp);
      if (res.containsKey('error')) {
        emit(AuthFailure(_decodeUtf8(res['error'])));
      } else {
        emit(OtpVerified());
      }
    } catch (e) {
      emit(AuthFailure(_decodeUtf8(e.toString())));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authService.register({
        'email': event.email,
        'password': event.password,
        'username': event.username,
        'hoten': event.hoten,
        'gioitinh': event.gioitinh,
        'diachi': event.diachi,
        'dienthoai': event.dienthoai,
        'ngaysinh': event.ngaysinh,
        'cmnd': event.cmnd,
      });
      if (res.containsKey('error')) {
        emit(AuthFailure(res['error']));
      } else if (res.containsKey('user')) {
        emit(RegisterSuccess());
      } else {
        emit(const AuthFailure('Unexpected response from server'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    add(LogoutEvent());
  }

  String _decodeUtf8(String input) {
    try {
      return utf8.decode(input.runes.toList());
    } catch (e) {
      return input;
    }
  }
}
