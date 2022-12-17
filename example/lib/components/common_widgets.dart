/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-02 21:56:29
 * @LastEditors: TT
 * @LastEditTime: 2022-11-23 22:33:04
 */

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';

import '../config/dataconfig/data_config_index.dart';

/// 创建加载动画
Widget createLoadWidget() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10.r,
            ),
            color: Colors.white,
            boxShadow: [
              configShadow(),
            ],
          ),
          child: Column(
            children: [
              Image.asset(
                "assets/images/loadingg.gif",
                fit: BoxFit.scaleDown,
                width: 60.w,
                height: 60.w,
              ),
              Text(
                "加载中...",
                style: FontConfig().fontBold12Black,
              )
            ],
          ),
        )
      ],
    ),
  );
}

// 空数据动图
// 空数据动图
Widget createNoDataWidget() {
  return Container(
    width: 200.w,
    height: 200.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        10,
      ),
    ),
    child: Image.asset(
      "assets/images/img-record.png",
      fit: BoxFit.scaleDown,
    ),
  );
}

// 创建地址按钮
Widget configbuildbottomBtn(
    {String? name,
    Color? textcolor = Colors.white,
    Color? color = Colors.orange,
    VoidCallback? onPressed}) {
  return Container(
    color: Colors.white,
    width: SizeMacro.screenWidth,
    height: 50 + ScreenUtil().bottomBarHeight,
    child: Column(
      children: [
        SizedBox(
          width: SizeMacro.screenWidth,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color),
              side: MaterialStateProperty.all(
                BorderSide(color: color!, width: 1),
              ),
            ),
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              }
            },
            child: Text(
              name ?? "",
              style: TextStyle(color: textcolor, fontSize: 16),
            ),
          ),
        )
      ],
    ),
  );
}

/// 创建灰色阴影
BoxShadow configShadow() {
  return BoxShadow(
    color: HzyColorConfig().colc3c3c3.withOpacity(0.4),
    offset: const Offset(0, 0),
    blurRadius: 10.0,
    spreadRadius: 0,
  );
}

/// 创建绿色阴影
BoxShadow configgeryShadow() {
  return BoxShadow(
    color: CommentColorS.grey.withOpacity(0.6),
    blurRadius: 8.0,
  );
}

/// 创建主题色阴影
BoxShadow configThemeShadow() {
  return BoxShadow(
    color: HzyColorConfig().colthemes.withOpacity(0.8),
    offset: const Offset(0, 3),
    blurRadius: 10,
    spreadRadius: 0,
  );
}

/// 显示toast msg
/// 传content 后,如果没传ontap 会调用返回上一个界面的方法
/// type == 1 普通 toast , 2 成功toast 3 失败toast
void showtoastmsg(String msg,
    {int type = 1, BuildContext? context, Function()? ontap}) {
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
  if (type == 1) {
    EasyLoading.showToast(msg);
  } else if (type == 2) {
    EasyLoading.showSuccess(msg);
  } else if (type == 3) {
    EasyLoading.showError(msg);
  }
  if (ontap != null || context != null) {
    Future.delayed(EasyLoading.instance.displayDuration).then((value) {
      if (ontap != null) {
        ontap();
      } else {
        Navigator.of(context!).pop();
      }
    });
  }
}

/// 创建黑色渐变色
createLine({
  AlignmentGeometry begin = Alignment.topCenter,
  AlignmentGeometry end = Alignment.bottomCenter,
}) {
  return LinearGradient(
    //渐变位置
    begin: begin, //右上
    end: end, //左下
    stops: const [0.0, 0.25, 0.75, 1.0], //[渐变起始点, 渐变结束点]
    tileMode: TileMode.mirror,
    //渐变颜色[始点颜色, 结束颜色]
    colors: [
      CommentColorS.col000000.withOpacity(0.6),
      CommentColorS.col000000.withOpacity(0.5),
      CommentColorS.col000000.withOpacity(0.2),
      CommentColorS.col000000.withOpacity(0),
    ],
  );
}

Widget commonTextField(
  BuildContext context, {
  TextAlign textAlign = TextAlign.left,
  TextEditingController? textEditingController,
  String? hintText,
  double? fontsize = 14,
  Color? fontColor = Colors.black,
  Color? hintColor = CommentColorS.colcccccc,
  Function? ontap,
  TextStyle? style,
  TextStyle? hintstyle,
  double? maxHeight = 30,
  TextInputType? keyboardType,
  int? maxLength,
  Function(String value)? onChange,
  Function()? ontapclear,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: maxHeight ?? 50,
    ),
    child: TextField(
      keyboardType: keyboardType,
      textAlign: textAlign,
      maxLength: maxLength,
      style: style ?? TextStyleMacor.fontMedium(fontsize!, fontColor!),
      controller: textEditingController,
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          hintText: hintText,
          hintStyle: hintstyle ??
              TextStyleMacor.fontMedium(
                fontsize!,
                hintColor!,
              ),
          suffixIcon: textEditingController != null
              ? (textEditingController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        if (ontapclear != null) {
                          ontapclear();
                        }
                        textEditingController.clear();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: HzyColorConfig().col5a5a5a,
                        size: 20.w,
                      ),
                    )
                  : null)
              : null),
      onTap: () {
        if (ontap != null) {
          ontap();
        }
      },
      onChanged: (value) {
        if (onChange != null) {
          onChange(value);
        }
      },
      onEditingComplete: () {
        CommentTools.keydissmiss(context);
      },
    ),
  );
}
