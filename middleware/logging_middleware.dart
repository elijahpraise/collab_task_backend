import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';

Middleware loggingMiddleware() {
  return (handler) {
    return (context) async {
      final request = context.request;
      final method = request.method;
      final uri = request.uri;

      log('${DateTime.now()}: $method $uri');

      final response = await handler(context);

      log('${DateTime.now()}: $method $uri - ${response.statusCode}');

      return response;
    };
  };
}
