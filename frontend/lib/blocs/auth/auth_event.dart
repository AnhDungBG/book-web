abstract class AuthEvent {
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class GetUserInfoEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String hoten;
  final String gioitinh;
  final String diachi;
  final String dienthoai;
  final String ngaysinh;
  final String cmnd;

  RegisterEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.hoten,
    required this.gioitinh,
    required this.diachi,
    required this.dienthoai,
    required this.ngaysinh,
    required this.cmnd,
  });
}

class VerifyEmailEvent extends AuthEvent {
  final String email;

  VerifyEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  VerifyOtpEvent(this.email, this.otp);

  @override
  List<Object> get props => [email, otp];
}
