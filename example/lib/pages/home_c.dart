/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 11:41:42
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:55:06
 */

import 'package:example/utils/getx_util_tool.dart';
import 'package:hzy_normal_network/hzy_normal_client.dart';
import 'package:hzy_normal_network/hzy_normal_http_config.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';

import '../components/common_index.dart';

class HomeC extends CommonGetXController {
  var text = "点我啊".obs;

  void tapbutton() {
    request(
        path: "Work/GetChuFangOrderInfo",
        data: {"menZhenH": "MZ20221018-00001-0006"});
  }
}
