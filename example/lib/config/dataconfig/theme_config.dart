/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 10:41:01
 * @LastEditors: TT
 * @LastEditTime: 2022-10-29 10:48:28
 */


import 'package:flutter/material.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';

import '../../utils/theme_tool.dart';

class HzyColorSring {
  static String coltheme = "theme";
  static String colffffff = "ffffff";
  static String col000000 = "000000";
  static String colefedf3 = "efedf3";
  static String col666666 = "666666";
  static String col999999 = "999999";
  static String colc3c3c3 = "c3c3c3";
  static String coldddddd = "dddddd";
  static String cole8e8e8 = "e8e8e8";
  static String cola6a6a6 = 'a6a6a6';
  static String cole5e5e5 = "e5e5e5";
  static String colonlywhite = "colonlywhite";
  static String colababab = "ababab";
  static String col5a5a5a = "5a5a5a";
  static String coldadada = "dadada";
  static String cole9e9e9 = "e9e9e9";
  static String colb0b0b0 = "b0b0b0";

  /// 白色背景 黑色字体
  static String whitebgblacktextcolor = "whiteback";

  /// 协议字体颜色
  static String agreementtextcolor = 'agreementextcolor';
}

class HzyColors {
  /// 白色背景 黑色字体
  static const Color col181818 = Color(0xff181818);
  static const Color cold3d3d3 = Color(0xffd3d3d3);

  /// 协议字体颜色
  static const Color col61678b = Color(0xff61678b);
  static const Color col8b8ca8 = Color(0xff8b8ca8);

  /// 三级灰色
  static const Color colb0b0b0 = Color(0xffb0b0b0);
  static const Color col606060 = Color(0xff606060);
}

class HzyThemeColor extends AbsThemeColorConfig {
  HzyThemeColor._internal();
  factory HzyThemeColor() => _instance;
  static final HzyThemeColor _instance = HzyThemeColor._internal();

  @override
  Map<String, Color?> get lightInfo => {
        HzyColorSring.coltheme: CommentColorS.col2865ff,
        HzyColorSring.colffffff: CommentColorS.colffffff,
        HzyColorSring.col000000: CommentColorS.col000000,
        HzyColorSring.colefedf3: CommentColorS.colefedf3,
        HzyColorSring.col666666: CommentColorS.col666666,
        HzyColorSring.col999999: CommentColorS.col999999,
        HzyColorSring.colc3c3c3: CommentColorS.colc3c3c3,
        HzyColorSring.cola6a6a6: CommentColorS.cola6a6a6,
        HzyColorSring.colonlywhite: CommentColorS.colffffff,
        HzyColorSring.coldddddd: CommentColorS.coldddddd,
        HzyColorSring.cole8e8e8: CommentColorS.cole8e8e8,
        HzyColorSring.cole5e5e5: CommentColorS.cole5e5e5,
        HzyColorSring.colababab: CommentColorS.colababab,
        HzyColorSring.col5a5a5a: CommentColorS.col5a5a5a,
        HzyColorSring.coldadada: CommentColorS.coldadada,
        HzyColorSring.cole9e9e9: CommentColorS.cole9e9e9,
        HzyColorSring.whitebgblacktextcolor: HzyColors.col181818,
        HzyColorSring.agreementtextcolor: HzyColors.col61678b,
        HzyColorSring.colb0b0b0: HzyColors.colb0b0b0,
      };
  @override
  Map<String, Color?> get darkInfo => {
        HzyColorSring.coltheme: CommentColorS.col2865ff,
        HzyColorSring.colffffff: HzyColors.col181818,
        HzyColorSring.col000000: CommentColorS.colffffff,
        HzyColorSring.colefedf3: CommentColorS.col151515,
        HzyColorSring.col666666: CommentColorS.colCACACA,
        HzyColorSring.col999999: CommentColorS.col7C7C7C,
        HzyColorSring.colc3c3c3: CommentColorS.col101010,
        HzyColorSring.cola6a6a6: CommentColorS.col4d4d4d,
        HzyColorSring.colonlywhite: CommentColorS.colffffff,
        HzyColorSring.coldddddd: CommentColorS.col2d2d2d,
        HzyColorSring.cole8e8e8: CommentColorS.col0e0e0e,
        HzyColorSring.cole5e5e5: CommentColorS.col909090,
        HzyColorSring.colababab: CommentColorS.col505050,
        HzyColorSring.col5a5a5a: CommentColorS.col909090,
        HzyColorSring.coldadada: CommentColorS.coldadada,
        HzyColorSring.cole9e9e9: CommentColorS.col0e0e0e,
        HzyColorSring.whitebgblacktextcolor: HzyColors.cold3d3d3,
        HzyColorSring.agreementtextcolor: HzyColors.col8b8ca8,
        HzyColorSring.colb0b0b0: HzyColors.col606060,
      };
  @override
  bool loadThemeModel() {
    return ThemeTool.isdark();
  }
}
