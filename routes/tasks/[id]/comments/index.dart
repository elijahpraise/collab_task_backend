import 'dart:convert';
import 'dart:io';

import 'package:collab_task_backend/features/tasks/dtos/create_comment_dto.dart';
import 'package:collab_task_backend/features/tasks/repository/comment_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String task) async {
  if (context.request.method case HttpMethod.get) {
    return _get(task);
  } else if (context.request.method case HttpMethod.post) {
    return _post(context, task);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(String task) async {
  try {
    final comments = await commentRepository.getCommentsByTaskId(task);
    return Response(
      body: jsonEncode(comments.map((c) => c.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _post(RequestContext context, String task) async {
  try {
    final user = context.read<String>();

    final body = await context.request.body();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final content = data['content'] as String?;

    if (content == null || content.trim().isEmpty) {
      return Response(
        statusCode: HttpStatus.badRequest,
        body: jsonEncode({'error': 'Content required'}),
      );
    }
    final dto = CreateCommentDto(task: task, author: user, content: content);
    final comment = await commentRepository.createComment(dto);
    return Response(
      statusCode: HttpStatus.created,
      body: jsonEncode(comment.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
