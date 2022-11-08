/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 10:40:49
 * @LastEditors: TT
 * @LastEditTime: 2022-10-29 10:47:12
 */


import 'package:flutter/material.dart';
import 'theme_config.dart';

class HzyColorConfig {
  // HzyColorConfig._internal();
  // factory HzyColorConfig() => _instance;
  // static late final HzyColorConfig _instance = HzyColorConfig._internal();

  /// 白色背景 黑色字体颜色
  Color wbgblacktextcolor =
      HzyThemeColor().confgColor(HzyColorSring.whitebgblacktextcolor);

  /// 白色背景颜色
  Color whitebackgroundColor =
      HzyThemeColor().confgColor(HzyColorSring.colffffff);

  Color colthemes = HzyThemeColor().confgColor(HzyColorSring.coltheme);

  Color col000000 = HzyThemeColor().confgColor(HzyColorSring.col000000);
  Color colefedf3 = HzyThemeColor().confgColor(HzyColorSring.colefedf3);
  Color col666666 = HzyThemeColor().confgColor(HzyColorSring.col666666);
  Color col999999 = HzyThemeColor().confgColor(HzyColorSring.col999999);
  Color colc3c3c3 = HzyThemeColor().confgColor(HzyColorSring.colc3c3c3);

  Color coldddddd = HzyThemeColor().confgColor(HzyColorSring.coldddddd);

  /// 二级灰色字体颜色
  Color col5a5a5a = HzyThemeColor().confgColor(HzyColorSring.col5a5a5a);

  /// 输入框 place 字体颜色
  Color colplacetextcolor = HzyThemeColor().confgColor(HzyColorSring.cola6a6a6);

  /// 纯白色背景
  Color colonlywhite = HzyThemeColor().confgColor(HzyColorSring.colonlywhite);

  /// 灰色背景颜色
  Color backgroudgrey = HzyThemeColor().confgColor(HzyColorSring.cole8e8e8);

  /// 分割线颜色
  Color linecolor = HzyThemeColor().confgColor(HzyColorSring.cole5e5e5);

  Color colore9e9e9 = HzyThemeColor().confgColor(HzyColorSring.cole9e9e9);

  /// 发布文章 背景颜色
  Color pusbulishbackgroundColor = const Color(0xff181818);

  /// 协议字体颜色
  Color agreementtextcolor =
      HzyThemeColor().confgColor(HzyColorSring.agreementtextcolor);

  /// 三级说明字体灰色
  Color colb0b0b0 = HzyThemeColor().confgColor(HzyColorSring.colb0b0b0);
}
