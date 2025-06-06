import 'dart:convert';
import 'dart:io';

import 'package:collab_task_backend/features/tasks/dtos/create_task_dto.dart';
import 'package:collab_task_backend/features/tasks/repository/task_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String column) async {
  if (context.request.method case HttpMethod.get) {
    return _get(column);
  } else if (context.request.method case HttpMethod.post) {
    return _post(context, column);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(String column) async {
  try {
    final tasks = await taskRepository.getTasksByColumnId(column);
    return Response(
      body: jsonEncode(tasks.map((t) => t.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _post(RequestContext context, String column) async {
  try {
    final user = context.read<String>();
    final body = await context.request.body();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final title = data['title'] as String?;
    final description = data['description'] as String? ?? '';
    final assignee = data['assignee'] as String? ?? user;
    final deadlineStr = data['deadline'] as String?;
    final tags = List<String>.from(data['tags'] as List<String>? ?? []);

    if (title == null) {
      return Response(
        statusCode: HttpStatus.badRequest,
        body: jsonEncode({'error': 'Title required'}),
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
    final dto = CreateTaskDto(
      title: title,
      description: description,
      column: column,
      assignee: assignee,
      tags: tags,
      deadline: deadline,
    );
    final task = await taskRepository.createTask(dto);

    return Response(
      statusCode: HttpStatus.created,
      body: jsonEncode(task.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
