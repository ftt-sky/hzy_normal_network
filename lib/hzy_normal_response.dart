/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:26:14
 * @LastEditors: TT
 * @LastEditTime: 2022-11-28 22:19:53
 */

import 'package:hzy_normal_network/hzy_normal_exception.dart';

class HzyNormalResponse {
  late bool ok;
  dynamic data;
  String? msg;
  HzyNormalExceeption? error;
  Map<String, dynamic>? response;

  HzyNormalResponse.success({
    required dynamic netdata,
    Map<String, dynamic>? response,
    String? reqmsg,
  }) {
    data = netdata;
    msg = reqmsg;
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
    msg = errorMsg;
    error = HzyNormalExceeption(msg, errorCode);
    ok = false;
  }

  HzyNormalResponse.failureFormResponse({dynamic data}) {
    error = BadResponseException();
    ok = false;
  }

  HzyNormalResponse.failureFromError([HzyNormalExceeption? requeserror]) {
    error = requeserror ?? UnknownException();
    ok = false;
  }
}
