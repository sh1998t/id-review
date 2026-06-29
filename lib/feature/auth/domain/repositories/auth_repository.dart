import '../../../../core/types/typedefs.dart';
import '../../data/models/login_request.dart';

abstract class AuthRepository {
  ResultFuture<void> login(LoginRequest request);
}
