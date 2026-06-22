import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  ApiHelper._();

  static const _divider =
      '══════════════════════════════════════════════════';
  static const _subDivider =
      '──────────────────────────────────────────────────';

  static Future<http.Response> get(Uri url,
      {Map<String, String>? headers}) async {
    _logRequest('GET', url, headers: headers);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.get(url, headers: headers);
      stopwatch.stop();
      _logResponse('GET', url, response, stopwatch.elapsedMilliseconds);
      return response;
    } catch (e) {
      stopwatch.stop();
      _logError('GET', url, e, stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  static Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    _logRequest('POST', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.post(url, headers: headers, body: body);
      stopwatch.stop();
      _logResponse('POST', url, response, stopwatch.elapsedMilliseconds);
      return response;
    } catch (e) {
      stopwatch.stop();
      _logError('POST', url, e, stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  static Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    _logRequest('PUT', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.put(url, headers: headers, body: body);
      stopwatch.stop();
      _logResponse('PUT', url, response, stopwatch.elapsedMilliseconds);
      return response;
    } catch (e) {
      stopwatch.stop();
      _logError('PUT', url, e, stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  static Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    _logRequest('DELETE', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.delete(url, headers: headers, body: body);
      stopwatch.stop();
      _logResponse('DELETE', url, response, stopwatch.elapsedMilliseconds);
      return response;
    } catch (e) {
      stopwatch.stop();
      _logError('DELETE', url, e, stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  // -------- Logging --------

  static void _logRequest(String method, Uri url,
      {Map<String, String>? headers, Object? body}) {
    if (!kDebugMode) return;
    debugPrint('\n$_divider');
    debugPrint('REQUEST: $method $url');
    debugPrint(_subDivider);
    if (headers != null && headers.isNotEmpty) {
      debugPrint('Headers:');
      for (final entry in headers.entries) {
        debugPrint('  ${entry.key}: ${_maskSensitive(entry.key, entry.value)}');
      }
    }
    if (body != null) {
      debugPrint('Body:');
      debugPrint('  ${_prettyBody(body)}');
    }
    debugPrint(_subDivider);
  }

  static void _logResponse(
      String method, Uri url, http.Response response, int durationMs) {
    if (!kDebugMode) return;
    final status = response.statusCode;
    final tag = status >= 200 && status < 300 ? 'SUCCESS' : 'FAILED';
    debugPrint(
        'RESPONSE: $tag $status  ($method $url)  [${durationMs}ms]');
    debugPrint(_subDivider);
    debugPrint('Response Body:');
    debugPrint('  ${_prettyJson(response.body)}');
    debugPrint('$_divider\n');
  }

  static void _logError(
      String method, Uri url, Object error, int durationMs) {
    if (!kDebugMode) return;
    debugPrint('RESPONSE: ERROR  ($method $url)  [${durationMs}ms]');
    debugPrint('  $error');
    debugPrint('$_divider\n');
  }

  static String _maskSensitive(String key, String value) {
    if (key.toLowerCase() == 'authorization' && value.length > 20) {
      return '${value.substring(0, 15)}...${value.substring(value.length - 4)}';
    }
    return value;
  }

  static String _prettyBody(Object body) {
    if (body is String) return _prettyJson(body);
    if (body is Map) {
      final safe = Map<String, dynamic>.from(body);
      if (safe.containsKey('password')) safe['password'] = '***';
      return _formatJson(safe);
    }
    return body.toString();
  }

  static String _prettyJson(String raw) {
    try {
      return _formatJson(jsonDecode(raw));
    } catch (_) {
      return raw.length > 500 ? '${raw.substring(0, 500)}...' : raw;
    }
  }

  static String _formatJson(Object? obj) =>
      const JsonEncoder.withIndent('  ').convert(obj);
}
