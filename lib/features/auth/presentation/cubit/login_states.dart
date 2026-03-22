abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

class PasswordResetLoading extends LoginState {}

class PasswordResetSuccess extends LoginState {}

class PasswordResetError extends LoginState {
  final String message;
  PasswordResetError(this.message);
}
