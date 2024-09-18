import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repository/user_local_repository.dart';
import '../data_source/user_loacal_data_source.dart';

class UserLocalRepositoryImpl implements UserLocalRepository {
  final UserLocalDataSource _dataSource;

  UserLocalRepositoryImpl(this._dataSource);

  @override
  Future<void> saveUser(User user) => _dataSource.saveUser(user);

  @override
  Map<String, dynamic>? getUser() => _dataSource.getUser();

  @override
  Future<void> deleteUser() => _dataSource.deleteUser();
}
