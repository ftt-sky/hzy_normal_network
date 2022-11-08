/*
 * @Description: 
 * @Version: 2.0
 * @Autor: ftt
 * @Date: 2022-06-09 11:19:38
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:30:41
 */

import 'package:flutter/material.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';
import '../config/dataconfig/hzy_color_config.dart';
import 'common_getx_controller.dart';
import 'common_place_holder_widget.dart';

abstract class CommonGetXWidget<T extends CommonGetXController>
    extends NormaGetxView<T> {
  CommonGetXWidget({Key? key}) : super(key: key);

  /// 创建失败 界面
  @override
  Widget? createErrorWidget() {
    return CommonPlaceHoldPage(
      placeHoldType: controller.placeHoldType,
      ontap: (placeHoldType) {
        controller.configreload();
      },
    );
  }

  @override
  Color? createLeadingIconColor() {
    return HzyColorConfig().col000000;
  }

  @override
  Color? createAppBarTextColor() {
    return HzyColorConfig().col000000;
  }
}
