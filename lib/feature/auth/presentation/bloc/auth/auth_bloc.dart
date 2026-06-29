import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:id_renew/core/errors/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/login_request.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<LoginEvent>(_onLogin);
    on<ResetAuthStateEvent>((event, emit) {
      emit(const AuthState());
    });
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        isLoggedIn: false,
      ),
    );

    final result = await _authRepository.login(event.request);

    result.fold(
      (error) => emit(
        state.copyWith(
          isLoading: false,
          error: error,
          isLoggedIn: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          error: null,
        ),
      ),
    );
  }
}
