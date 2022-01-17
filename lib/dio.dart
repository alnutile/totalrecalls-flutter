import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:totalrecalls/providers/auth.dart';

Dio dio() {
  var dio = Dio(
    BaseOptions(
        baseUrl: "http://totalrecalls.test/api/",
        responseType: ResponseType.plain,
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        }),
  );

  // ignore: avoid_single_cascade_in_expression_statements
  dio
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => requestInterceptor(options, handler),
      ),
    );

  return dio;
}

dynamic requestInterceptor(RequestOptions options, handler) async {
  if (options.headers.containsKey('auth')) {
    var token = await Auth().getToken();

    options.headers.addAll({'Authorization': "Bearer $token"});
  }

  return handler.next(options);
}
