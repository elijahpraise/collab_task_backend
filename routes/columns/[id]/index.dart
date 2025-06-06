import 'dart:convert';
import 'dart:io';

import 'package:collab_task_backend/features/tasks/dtos/update_column_dto.dart';
import 'package:collab_task_backend/features/tasks/repository/column_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method case HttpMethod.put) {
    return _put(context, id);
  } else if (context.request.method case HttpMethod.delete) {
    return _delete(id);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Future<Response> _put(RequestContext context, String id) async {
  try {
    final body = await context.request.body();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final name = data['name'] as String?;

    if (name == null) {
      return Response(
        statusCode: HttpStatus.badRequest,
        body: jsonEncode({'error': 'Name required'}),
      );
    }
    final dto = UpdateColumnDto(id: id, name: name);
    final column = await columnRepository.updateColumn(dto);
    if (column == null) {
      return Response(statusCode: HttpStatus.notFound);
    }

    return Response(
      body: jsonEncode(column.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _delete(String id) async {
  try {
    final success = await columnRepository.deleteColumn(id);
    if (!success) {
      return Response(statusCode: HttpStatus.notFound);
    }
    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
