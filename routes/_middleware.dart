import 'package:dart_frog/dart_frog.dart';

import '../middleware/logging_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(loggingMiddleware());
}
