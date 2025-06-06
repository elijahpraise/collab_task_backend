import 'dart:convert';
import 'dart:io';

import 'package:collab_task_backend/features/tasks/dtos/create_column_dto.dart';
import 'package:collab_task_backend/features/tasks/repository/column_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String workspace) async {
  if (context.request.method case HttpMethod.get) {
    return _get(workspace);
  } else if (context.request.method case HttpMethod.post) {
    return _post(context, workspace);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Future<Response> _get(String workspace) async {
  try {
    final columns = await columnRepository.getColumnsByWorkspaceId(workspace);
    return Response(
      body: jsonEncode(columns.map((c) => c.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _post(RequestContext context, String workspace) async {
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
    final dto = CreateColumnDto(name: name, workspace: workspace);
    final column = await columnRepository.createColumn(dto);
    return Response(
      statusCode: HttpStatus.created,
      body: jsonEncode(column.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
