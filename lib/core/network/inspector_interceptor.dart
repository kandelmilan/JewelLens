import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:requests_inspector/requests_inspector.dart';

/// Wraps RequestsInspectorInterceptor so it's only ever active in debug builds.
/// Returns an empty list in release, so it's a no-op — safe to always include
/// in the interceptor list without an `if` check at the call site.
List<Interceptor> buildInspectorInterceptors() {
  if (!kDebugMode) return [];
  return [RequestsInspectorInterceptor()];
}