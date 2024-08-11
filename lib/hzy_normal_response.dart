/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:26:14
 * @LastEditors: TT-hzy
 * @LastEditTime: 2024-08-11 13:30:51
 */

import 'package:hzy_normal_network/hzy_normal_exception.dart';

class HzyNormalResponse {
  late bool ok;
  late dynamic data;
  late String msg;
  HzyNormalExceeption? error;
  Map<String, dynamic>? response;

  HzyNormalResponse.success({
    required dynamic netData,
    Map<String, dynamic>? response,
    String reqMsg = "请求成功",
  }) {
    data = netData;
    msg = reqMsg;
    ok = true;
    if (response != null) {
      this.response = response;
    }
  }

  HzyNormalResponse.fail({
    required this.data,
    String? errorMsg = '网络请求失败',
    int? errorCode = 404,
    Map<String, dynamic>? response,
  }) {
    msg = errorMsg ?? "网络请求失败";
    error = HzyNormalExceeption(msg, errorCode);
    ok = false;
  }

  HzyNormalResponse.failureFormResponse({
    dynamic data,
  }) {
    error = BadResponseException();
    ok = false;
  }

  HzyNormalResponse.failureFromError([
    HzyNormalExceeption? requesError,
  ]) {
    error = requesError ?? UnknownException();
    ok = false;
  }
}
