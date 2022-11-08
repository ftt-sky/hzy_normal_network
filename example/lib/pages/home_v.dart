/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 11:40:27
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:53:32
 */

import 'package:flutter/material.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';
import '../components/common_getx_widget.dart';
import 'home_c.dart';

class HomeV extends CommonGetXWidget<HomeC> {
  HomeV({Key? key}) : super(key: key);
  @override
  HomeC get controller => Get.put(HomeC());

  @override
  Widget createBody(BuildContext context) {
    return InkWell(
      child: Text(controller.text.value),
      onTap: () {
        controller.tapbutton();
      },
    );
  }
}
