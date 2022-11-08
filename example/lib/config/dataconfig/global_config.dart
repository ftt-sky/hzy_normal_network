/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 16:12:31
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:51:26
 */

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hzy_normal_network/hzy_normal_network.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';
import '../../components/common_widgets.dart';
import 'normal_config.dart';

class GlobalConfig {
  static init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initThirdParty();
    await initNetWork();
  }

  /// 初始化第三发
  static initThirdParty() async {
    EasyLoading.instance.displayDuration = const Duration(
      milliseconds: 1500,
    );
  }

  static initNoramlDefault() {
    CommonBaseConfig.loadWidget = createLoadWidget();
  }

  /// 配置网络请求
  static initNetWork() async {
    HzyNormalDefaultTransFormer.getInstance().setHttpConfig(
      config: HzyNormalHttpResponeConfig(
        status: "IsSuccess",
        code: "Stamp",
        msg: "Message",
        data: "Data",
        successcode: 0,
      ),
    );

    // 注入网络请求组件
    Get.put(
      HzyNormalClient(
        normalHttpConfig: HzyNormalHttpConfig(
          baseUrl: NormalConfig.baseUrl,
          interceptors: [
            // SmallPInterceptor(),
          ],
        ),
      ),
      permanent: true,
      tag: HttpClient.defaultClientTag,
    );
  }
}
