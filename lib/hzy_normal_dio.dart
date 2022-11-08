/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-02 16:14:08
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 09:55:10
 */

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'hzy_normal_http_config.dart';

class HzyNoramlDio with DioMixin implements Dio {
  HzyNoramlDio({BaseOptions? options, HzyNormalHttpConfig? httpConfig}) {
    options ??= BaseOptions(
      baseUrl: httpConfig?.baseUrl ?? "",
      contentType: 'application/json',
      connectTimeout: httpConfig?.connectTimeout,
      sendTimeout: httpConfig?.sendTimeout,
      receiveTimeout: httpConfig?.receiveTimeout,
    );
    this.options = options;
    if (kDebugMode) {
      interceptors.add(
        LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: true,
          request: true,
          requestBody: true,
        ),
      );
    }
  }
}
