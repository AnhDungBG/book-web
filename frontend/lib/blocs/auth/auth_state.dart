import 'package:flutter_web_fe/core/data/models/auth_model.dart';

abstract class AuthState {
  const AuthState();

  get cart => null;
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  List<Object?> get props => [error];
}

class Unauthenticated extends AuthState {}

class EmailVerificationSent extends AuthState {
  final String message;

  const EmailVerificationSent({required this.message});

  List<Object?> get props => [message];
}

class OtpVerified extends AuthState {}

class RegisterSuccess extends AuthState {}
