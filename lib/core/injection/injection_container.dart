import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_chat/data/data_source/user_loacal_data_source.dart';
import 'package:we_chat/data/repository/user_local_repository_imp.dart';
import 'package:we_chat/domain/repository/user_local_repository.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<UserLocalDataSource>(
      UserLocalDataSource(sharedPreferences));
  getIt.registerSingleton<UserLocalRepository>(
      UserLocalRepositoryImpl(getIt<UserLocalDataSource>()));
}
