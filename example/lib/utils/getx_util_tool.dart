/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 16:09:56
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:55:33
 */

import 'package:hzy_normal_network/hzy_normal_network.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';

HzyNormalClient defaultClient() {
  return Get.find<HzyNormalClient>(tag: HttpClient.defaultClientTag);
}

enum Method {
  get,
  post,
}

Future<HzyNormalResponse> request({
  required String path,
  dynamic data,
  Method method = Method.get,
}) async {
  HzyNormalResponse res;
  // if (method == Method.get) {
  res = await defaultClient().get(url: path, queryParameters: data);
  // }
  debugprint(res.error?.msg ?? "");
  return res;
}
