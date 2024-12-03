import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> fetchUsers();

  Future<UserDetailsEntity> fetchUserDetails(String userCode);

  Future<String> sendRequest(String userCode);

  Future<String> addToFavourites(String userCode);

  Future<String> removeFromFavourites(String userCode);
}