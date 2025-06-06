import 'dart:convert';
import 'dart:io';

import 'package:collab_task_backend/features/tasks/dtos/update_workspace_dto.dart';
import 'package:collab_task_backend/features/tasks/service/workspace_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method case HttpMethod.get) {
    return _get(id);
  } else if (context.request.method case HttpMethod.put) {
    return _put(context, id);
  } else if (context.request.method case HttpMethod.delete) {
    return _delete(id);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Future<Response> _get(String id) async {
  try {
    final workspace = await workspaceService.getWorkspace(id);
    if (workspace == null) {
      return Response(statusCode: HttpStatus.notFound);
    }
    return Response(
      body: jsonEncode(workspace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _put(RequestContext context, String id) async {
  try {
    final body = await context.request.body();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final name = data['name'] as String?;
    final description = data['description'] as String?;

    if (name == null || description == null) {
      var error = '';
      if (name == null) error = 'Name required';
      if (description == null) error = 'Description required';
      if (name == null || description == null) {
        error = 'Name and description required';
      }
      return Response(
        statusCode: HttpStatus.badRequest,
        body: jsonEncode({'error': error}),
      );
    }
    final dto =
        UpdateWorkspaceDto(id: id, name: name, description: description);
    final workspace = await workspaceService.updateWorkspace(dto);
    if (workspace == null) {
      return Response(statusCode: HttpStatus.notFound);
    }

    return Response(
      body: jsonEncode(workspace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _delete(String id) async {
  try {
    final success = await workspaceService.deleteWorkspace(id);
    if (!success) {
      return Response(statusCode: HttpStatus.notFound);
    }
    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
