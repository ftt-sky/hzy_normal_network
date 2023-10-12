/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:12:39
 * @LastEditors: TT
 * @LastEditTime: 2023-10-09 14:13:24
 */

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hzy_normal_network/hzy_normal_http_config.dart';
import 'package:hzy_normal_network/hzy_normal_parse.dart';
import 'package:hzy_normal_network/hzy_normal_response.dart';

import 'hzy_normal_transformer.dart';

class HzyNormalClient {
  static const defaultClientTag = "hzy_normal_network";
  final HzyNormalHttpConfig? _normalHttpConfig;
  late final Dio _noramlDio;
  Dio get dio => _noramlDio;
  HzyNormalClient({
    BaseOptions? options,
    HzyNormalHttpConfig? normalHttpConfig,
  })  : _normalHttpConfig = normalHttpConfig,
        _noramlDio = createDio(
          options: options,
          normalHttpConfig: normalHttpConfig,
        );

  static Dio createDio({
    BaseOptions? options,
    HzyNormalHttpConfig? normalHttpConfig,
  }) {
    options ??= BaseOptions(
      baseUrl: normalHttpConfig?.baseUrl ?? "",
      contentType: 'application/json',
      sendTimeout: Duration(seconds: normalHttpConfig?.sendTimeout ?? 30),
      receiveTimeout: Duration(seconds: normalHttpConfig?.receiveTimeout ?? 30),
      headers: normalHttpConfig?.headers,
    );
    Dio dio = Dio(options);

    if (normalHttpConfig?.interceptors?.isNotEmpty ?? false) {
      dio.interceptors.addAll(normalHttpConfig!.interceptors!);
    }
    if (kDebugMode && normalHttpConfig?.isNeedLog == true) {
      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
        request: true,
        requestBody: true,
        logPrint: (object) {
          log(object.toString());
        },
      ));
    }
    return dio;
  }

  Future<HzyNormalResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HzyNormalTransFormer? httpTransformer,
  }) async {
    try {
      var response = await _noramlDio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.caCheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return HzyNormalResponse.fail(
        data: e,
        errorMsg: e.toString(),
        errorCode: -1,
      );
    }
  }

  Future<HzyNormalResponse> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HzyNormalTransFormer? httpTransformer,
  }) async {
    try {
      var response = await _noramlDio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.caCheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<HzyNormalResponse> patch(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HzyNormalTransFormer? httpTransformer,
  }) async {
    try {
      var response = await _noramlDio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.caCheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<HzyNormalResponse> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    HzyNormalTransFormer? httpTransformer,
  }) async {
    try {
      var response = await _noramlDio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.caCheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<HzyNormalResponse> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    HzyNormalTransFormer? httpTransformer,
  }) async {
    try {
      var response = await _noramlDio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.caCheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<Response> download(
    String urlPath,
    savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    data,
    Options? options,
    HzyNormalTransFormer? httpTransformer,
  }) async {
    try {
      var response = await _noramlDio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<HzyNormalResponse> uploadImage(
    String uri,
    Uint8List image, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    HzyNormalTransFormer? httpTransformer,
  }) async {
    Map<String, dynamic> map = {};
    if (queryParameters != null) {
      map.addAll(queryParameters);
    }
    map["file"] = MultipartFile.fromBytes(image, filename: "iamge.png");
    FormData formData = FormData.fromMap(map);
    try {
      var response = await _noramlDio.post(
        uri,
        data: formData,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.caCheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }
}
