part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final LoginRequest request;

  LoginEvent({required this.request});
}

class ResetAuthStateEvent extends AuthEvent {}
