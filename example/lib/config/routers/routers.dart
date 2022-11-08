/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 11:11:05
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:45:04
 */

import 'package:example/config/dataconfig/page_id_config.dart';
import 'package:example/pages/home_v.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';

class RouterS {
  static List<GetPage> getAllRoutS() {
    return [GetPage(name: PageIdConfig.index, page: () => HomeV())];
  }
}
