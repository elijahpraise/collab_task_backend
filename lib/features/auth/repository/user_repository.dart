import 'dart:convert';

import 'package:collab_task_backend/features/auth/auth_index.dart';
import 'package:collab_task_backend/features/shared/repository/base_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:sqlite3/common.dart';

class UserRepository extends BaseRepository {
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> createUser(CreateUserDto dto) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final passwordHash = _hashPassword(dto.password);
      final dateCreated = DateTime.now();
      final lastUpdated = DateTime.now();
      database.execute('''
        INSERT INTO users (id, email, password_hash, username, date_created, last_updated)
        VALUES (?, ?, ?, ?, ?)
      ''', [
        id,
        dto.email,
        passwordHash,
        dto.username,
        dateCreated.toIso8601String(),
        lastUpdated.toIso8601String(),
      ]);

      return User(
        id: id,
        email: dto.email,
        passwordHash: passwordHash,
        username: dto.username,
        dateCreated: dateCreated,
      );
    } catch (e) {
      return null;
    }
  }

  Future<User?> authenticateUser(LoginDto dto) async {
    final passwordHash = _hashPassword(dto.password);

    final result = database.select(
      '''
      SELECT * FROM users WHERE email = ? AND password_hash = ?
    ''',
      [dto.email, passwordHash],
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return row.user;
  }

  Future<User?> getUserById(String id) async {
    final result = database.select('SELECT * FROM users WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    final row = result.first;
    return row.user;
  }
}

extension UserRowExt on Row {
  User get user {
    final row = this;
    return User.fromJson(row);
  }
}
