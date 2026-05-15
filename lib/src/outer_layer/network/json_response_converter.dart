import 'dart:convert';
import 'package:chopper/chopper.dart';

/// A [Converter] that only decodes JSON responses, without setting
/// `Content-Type` on outgoing requests (which breaks GET endpoints).
class JsonResponseConverter implements Converter {
  const JsonResponseConverter();

  @override
  Request convertRequest(Request request) {
    final req = request.copyWith(
      body: jsonEncode(request.body),
    );
    req.headers['Content-Type'] = 'application/json';
    return req;
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    final body = response.body;

    if (body is String && body.isNotEmpty) {
      final decoded = jsonDecode(body);
      return response.copyWith<BodyType>(body: decoded as BodyType);
    }

    return response.copyWith<BodyType>(body: body as BodyType);
  }
}
