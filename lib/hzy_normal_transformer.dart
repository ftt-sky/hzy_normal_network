/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:24:24
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:11:10
 */

import 'package:dio/dio.dart';

import 'hzy_normal_response.dart';

abstract class HzyNormalTransFormer {
  HzyNormalResponse parse(Response response);
}
