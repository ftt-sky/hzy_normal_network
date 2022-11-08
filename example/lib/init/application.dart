/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 11:09:33
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:53:13
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';
import '/config/dataconfig/page_id_config.dart';
import '../config/routers/routers.dart';

class Application extends StatelessWidget {
  Application({Key? key}) : super(key: key);
  final easyLoading = EasyLoading.init();
  @override
  Widget build(BuildContext context) {
    String rootroutes = PageIdConfig.index;

    return ScreenUtilInit(
      designSize: const Size(375, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (content, child) {
        return GetMaterialApp(
          /// 入口路由
          initialRoute: rootroutes,
          title: "订单详情",

          /// 所有路由集合
          getPages: RouterS.getAllRoutS(),
          defaultTransition: Transition.noTransition,

          /// 是否显示 导航栏右上角 debug 标识
          debugShowCheckedModeBanner: false,
          builder: (context, child) => MediaQuery(
            /// 设置文字大小不随系统设置改变
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: easyLoading(context, child),
          ),
        );
      },
    );
  }
}
