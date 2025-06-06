import 'dart:convert';
import 'dart:io';

import 'package:collab_task_backend/features/tasks/dtos/update_task_dto.dart';
import 'package:collab_task_backend/features/tasks/repository/task_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method case HttpMethod.get) {
    return _get(id);
  } else if (context.request.method case HttpMethod.put) {
    return _put(context, id);
  } else if (context.request.method case HttpMethod.delete) {
    return _delete(id);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(String id) async {
  try {
    final task = await taskRepository.getTaskById(id);
    if (task == null) {
      return Response(statusCode: HttpStatus.notFound);
    }
    return Response(
      body: jsonEncode(task.toJson()),
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

    final title = data['title'] as String?;
    final description = data['description'] as String?;
    final deadlineStr = data['deadline'] as String?;
    final tagsData = data['tags'] as List<String>?;
    final tags = tagsData != null ? List<String>.from(tagsData) : null;

    if (title == null &&
        description == null &&
        deadlineStr == null &&
        tagsData == null) {
      return Response(
        statusCode: HttpStatus.badRequest,
        body: jsonEncode({'error': 'Fields cannot be empty!'}),
      );
    }

    DateTime? deadline;
    if (deadlineStr != null) {
      try {
        deadline = DateTime.parse(deadlineStr);
      } catch (e) {
        return Response(
          statusCode: HttpStatus.badRequest,
          body: jsonEncode({'error': 'Invalid deadline format'}),
        );
      }
    }
    final dto = UpdateTaskDto(
      id: id,
      title: title,
      description: description,
      tags: tags,
      deadline: deadline,
    );
    final task = await taskRepository.updateTask(dto);

    if (task == null) {
      return Response(statusCode: HttpStatus.notFound);
    }

    return Response(
      body: jsonEncode(task.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _delete(String id) async {
  try {
    final success = await taskRepository.deleteTask(id);
    if (!success) {
      return Response(statusCode: HttpStatus.notFound);
    }
    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
