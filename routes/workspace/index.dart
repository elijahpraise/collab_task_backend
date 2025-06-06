import 'dart:convert';
import 'dart:io';

import 'package:collab_task_backend/features/tasks/dtos/create_workspace_dto.dart';
import 'package:collab_task_backend/features/tasks/service/workspace_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method case HttpMethod.get) {
    return _get(context);
  } else if (context.request.method case HttpMethod.post) {
    return _post(context);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Future<Response> _get(RequestContext context) async {
  try {
    final user = context.read<String>();
    final workspaces = await workspaceService.getUserWorkspaces(user);
    return Response(
      body: jsonEncode(workspaces.map((w) => w.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _post(RequestContext context) async {
  try {
    final user = context.read<String>();
    final body = await context.request.body();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final name = data['name'] as String?;
    final description = data['description'] as String? ?? '';

    if (name == null) {
      return Response(
        statusCode: HttpStatus.badRequest,
        body: jsonEncode({'error': 'Name required'}),
      );
    }

    final dto =
        CreateWorkspaceDto(name: name, description: description, user: user);

    final workspace = await workspaceService.createWorkspace(dto);
    return Response(
      statusCode: HttpStatus.created,
      body: jsonEncode(workspace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
