import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// flutter pub run build_runner build --delete-conflicting-outputs
final getIt = GetIt.instance;

@InjectableInit()
Future<void> initDi() async {
  getIt.init();
  return getIt.allReady();
}

Future<void> disposeDi() {
  return getIt.reset();
}

T inject<T extends Object>() {
  return GetIt.I.get<T>();
}

Future<T> injectAsync<T extends Object>() {
  return GetIt.I.getAsync<T>();
}
