/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 10:43:29
 * @LastEditors: TT
 * @LastEditTime: 2022-10-29 10:46:49
 */
/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-06-22 11:48:25
 * @LastEditors: TT
 * @LastEditTime: 2022-08-30 18:13:09
 */

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:hzy_normal_widget/hzy_normal_widget.dart';

class ThemeTool {
  /// 切换主题
  static changeTheme({int? type = 1}) {
    ThemeMode mode = getlocalprofileaboutThemeModel();
    ThemeData themeData = getlocalprofileaboutThemeData();
    EasyLoadingStyle easyLoadingStyle = EasyLoadingStyle.dark;
    if (mode == ThemeMode.dark) {
      easyLoadingStyle = EasyLoadingStyle.light;
    } else if (mode == ThemeMode.system) {
      if (!Get.isDarkMode) {
        easyLoadingStyle = EasyLoadingStyle.light;
      }
    }
    EasyLoading.instance.loadingStyle = easyLoadingStyle;
    Get.changeThemeMode(mode);
    Get.changeTheme(themeData);

    updateTheme();
  }

  static updateTheme() {
    Future.delayed(const Duration(milliseconds: 250), () {
      Get.forceAppUpdate();
    });
  }

  /// 获取本地 主题配置
  static getlocalprofileaboutThemeModel() {
    return ThemeMode.light;
  }

  static getlocalprofileaboutThemeData() {
    return ThemeData(brightness: Brightness.light);
  }

  static isdark() {
    return Get.isDarkMode;
  }
}
