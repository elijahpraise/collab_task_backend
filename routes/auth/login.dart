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

    if (email == null || password == null) {
      return Response(
        statusCode: HttpStatus.badRequest,
        body: jsonEncode({'error': 'Email and password required'}),
      );
    }

    final dto = LoginDto(email: email, password: password);
    final result = await authService.login(dto);

    if (result == null) {
      return Response(
        statusCode: HttpStatus.unauthorized,
        body: jsonEncode({'error': 'Invalid credentials'}),
      );
    }

    return Response(
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
