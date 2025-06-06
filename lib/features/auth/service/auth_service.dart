import 'package:collab_task_backend/features/auth/auth_index.dart';
import 'package:collab_task_backend/features/auth/repository/user_repository.dart';

final authService = AuthService();

class AuthService {
  final UserRepository _userRepository = UserRepository();
  final Map<String, String> _sessions = {};

  Future<Map<String, dynamic>?> login(LoginDto dto) async {
    final user = await _userRepository.authenticateUser(dto);
    if (user == null) return null;

    final token = DateTime.now().millisecondsSinceEpoch.toString();
    _sessions[token] = user.id;
    final json = user.toJson();
    json['token'] = token;
    return json;
  }

  Future<Map<String, dynamic>?> register(CreateUserDto dto) async {
    final user = await _userRepository.createUser(dto);
    if (user == null) return null;
    final token = DateTime.now().millisecondsSinceEpoch.toString();
    _sessions[token] = user.id;
    final json = user.toJson();
    json['token'] = token;
    return json;
  }

  String? validateToken(String token) {
    return _sessions[token];
  }

  void logout(String token) {
    _sessions.remove(token);
  }

  Future<User?> getUserFromToken(String token) async {
    final userId = validateToken(token);
    if (userId == null) return null;
    return _userRepository.getUserById(userId);
  }
}
