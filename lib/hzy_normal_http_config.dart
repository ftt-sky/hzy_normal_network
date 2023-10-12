/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:08:29
 * @LastEditors: TT
 * @LastEditTime: 2023-10-09 14:11:27
 */
/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-02 16:17:29
 * @LastEditors: TT
 * @LastEditTime: 2022-11-02 16:18:35
 */

import 'package:dio/dio.dart';

/// dio 配置项
class HzyNormalHttpConfig {
  final String? baseUrl;
  final String? proxy;
  final String? cookiesPath;
  final List<Interceptor>? interceptors;
  final int connectTimeout;
  final int sendTimeout;
  final int receiveTimeout;
  final bool isNeedLog;
  final Map<String, dynamic>? headers;

  /// 网络缓存 状态值
  final int caCheStatusCode;
  HzyNormalHttpConfig({
    this.baseUrl,
    this.proxy,
    this.headers,
    this.cookiesPath,
    this.interceptors,
    this.isNeedLog = true,
    this.caCheStatusCode = 304,
    this.connectTimeout = 30,
    this.sendTimeout = 30,
    this.receiveTimeout = 30,
  });
}
