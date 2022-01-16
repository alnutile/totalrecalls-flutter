import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

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

  return dio;
}
