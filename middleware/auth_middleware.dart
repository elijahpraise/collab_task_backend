import 'dart:io';

import 'package:collab_task_backend/features/auth/service/auth_service.dart';
import 'package:dart_frog/dart_frog.dart';

Middleware authMiddleware() {
  return (handler) {
    return (context) async {
      final request = context.request;
      final authHeader = request.headers['Authorization'];

      if (authHeader == null || !authHeader.startsWith('Token ')) {
        return Response(statusCode: HttpStatus.unauthorized);
      }

      final token = authHeader.substring(7);
      final user = await authService.getUserFromToken(token);

      if (user == null) return Response(statusCode: HttpStatus.unauthorized);

      return handler(context.provide<String>(() => user.id));
    };
  };
}
