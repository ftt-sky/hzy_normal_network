/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 16:24:51
 * @LastEditors: TT
 * @LastEditTime: 2022-11-02 09:45:34
 */

import 'package:hzy_normal_widget/hzy_normal_widget.dart';

import '../dataconfig/normal_config.dart';

class SmallPInterceptor extends Interceptor {
  SmallPInterceptor(
      {this.request = true,
      this.requestHeader = true,
      this.requestBody = true});
  bool request;
  bool requestHeader;
  bool requestBody;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Token'] = NormalConfig.userid;
    handler.next(options);
    debugprint(options.headers);
  }
}
