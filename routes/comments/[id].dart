import 'dart:io';

import 'package:collab_task_backend/features/tasks/repository/comment_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method case HttpMethod.delete) {
    return _get(id);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(String id) async {
  try {
    final success = await commentRepository.deleteComment(id);
    if (!success) {
      return Response(statusCode: HttpStatus.notFound);
    }
    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
