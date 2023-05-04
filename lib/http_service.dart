import 'package:dio/dio.dart';

class HttpService {
  late Dio _dio;
  final baseUrl = "https://chat4usnew.uc.r.appspot.com/";

  constructor() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      'Content-type': 'application/json; charset=utf-8',
      "Accept": "application/json",
      "Connection": "keep-alive",
      "Access-Control-Allow-Origin": "*"
    }));

    intializeInterceptors();
  }

  Future<Response> getRequest(String endpoint) async {
    Response response;
    try {
      response = await _dio.get(endpoint);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  Future<Response> postRequest(String endpoint, var requestBody) async {
    Response response;
    try {
      response = await _dio.post(endpoint, data: requestBody);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  intializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        print(e.message);
      },
      onRequest: (options, handler) {
        print("${options.method} ${options.path}");
      },
      onResponse: (e, handler) {
        print(e.data);
      },
    ));
  }
}
