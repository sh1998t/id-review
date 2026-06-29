import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

typedef DataMap = Map<String, dynamic>;

typedef ResultFuture<T> = Future<Either<Failure, T>>;
