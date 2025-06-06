import 'dart:convert';
import 'dart:io';

import 'package:collab_task_backend/features/auth/auth_index.dart';
import 'package:collab_task_backend/features/auth/service/auth_service.dart';
import 'package:collab_task_backend/utils/typedefs.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.body();
    final data = jsonDecode(body) as Json;

    final email = data['email'] as String?;
    final password = data['password'] as String?;
    final username = data['username'] as String?;

    if (email == null || password == null || username == null) {
      var error = '';
      if (email == null) error = 'Email required';
      if (password == null) error = 'Password required';
      if (username == null) error = 'Username required';
      if (email == null || password == null || username == null) {
        error = 'Email, password, and name required';
      }
      return Response(
        statusCode: HttpStatus.badRequest,
        body: jsonEncode({'error': error}),
      );
    }
    final dto =
        CreateUserDto(email: email, username: username, password: password);
    final result = await authService.register(dto);

    if (result == null) {
      return Response(
        statusCode: HttpStatus.conflict,
        body: jsonEncode({'error': 'User already exists'}),
      );
    }

    return Response(
      statusCode: HttpStatus.created,
      body: jsonEncode(result),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: jsonEncode({'error': 'Server error'}),
    );
  }
}
