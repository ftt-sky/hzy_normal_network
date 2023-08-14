/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:08:29
 * @LastEditors: TT
 * @LastEditTime: 2023-08-14 15:40:57
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

  HzyNormalHttpConfig({
    this.baseUrl,
    this.proxy,
    this.cookiesPath,
    this.interceptors,
    this.connectTimeout = 30,
    this.sendTimeout = 30,
    this.receiveTimeout = 30,
  });
}
