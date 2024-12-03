// lib/features/auth/domain/use_cases/sign_up.dart
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class FetchUsers {
  final UserRepository repository;

  FetchUsers(this.repository);

  Future<List<UserEntity>> call() async {
    return await repository.fetchUsers();
  }
}