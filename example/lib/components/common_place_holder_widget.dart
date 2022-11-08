/*
 * @Description: 
 * @Version: 2.0
 * @Autor: ftt
 * @Date: 2022-06-09 11:32:30
 * @LastEditors: TT
 * @LastEditTime: 2022-10-31 17:42:51
 */
import 'package:flutter/material.dart';
import 'package:hzy_normal_widget/hzy_normal_widget.dart';
import 'common_widgets.dart';

import '../config/dataconfig/data_config_index.dart';

enum CommonPlaceHoldType {
  /// 无网络
  nonetwork,

  /// 未登录
  nologin,

  ///空数据
  nothing,
}

class CommonPlaceHoldPage extends TTNormalStatefulWidget {
  const CommonPlaceHoldPage({Key? key, required this.placeHoldType, this.ontap})
      : super(key: key);
  final CommonPlaceHoldType placeHoldType;
  final Function(CommonPlaceHoldType num)? ontap;
  @override
  TTNormalState<TTNormalStatefulWidget> getState() {
    return _CommonPlaceHoldPageState();
  }
}

class _CommonPlaceHoldPageState extends TTNormalState<CommonPlaceHoldPage> {
  /// 属性
  ///
  ///

  @override
  bool get safeAreabottm => false;
  @override
  bool get safeAreatop => false;

  /// 生命周期
  ///
  ///

  /// 界面初始化
  @override
  void initDefaultState() {
    super.initDefaultState();
  }

  /// 界面销毁
  @override
  void initDefaultDispose() {
    super.initDefaultDispose();
  }

  /// 网路请求
  ///
  ///

  /// 构建视图
  ///
  ///

  @override
  Widget createBody(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: HzyColorConfig().whitebackgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          configplaceWidget(type: 1),
          Gaps.vGap30,
          configplaceWidget(type: 2),
          Gaps.vGap15,
          configplaceWidget(type: 4),
        ],
      ),
    );
  }

  /// 创建暂位图
  Widget createPlaceImageWidget() {
    return createNoDataWidget();
  }

  /// 创建暂位图标语
  Widget createPlaceTitleWidget() {
    String title = "";
    if (widget.placeHoldType == CommonPlaceHoldType.nonetwork) {
      title = "暂无网络,请稍后重试";
    } else if (widget.placeHoldType == CommonPlaceHoldType.nothing) {
      title = "暂无数据";
    }
    return Text(
      title,
      style: FontConfig().fontBold18Black,
    );
  }

  /// 创建暂位图描述语
  Widget createPlaceMessageWidget() {
    return Container();
  }

  /// 创建暂位图 刷新按钮
  Widget createPlaceReloadBtnWidget() {
    return InkWell(
      onTap: () async {
        if (widget.ontap != null) {
          widget.ontap!(widget.placeHoldType);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 100.w,
        height: 40.w,
        decoration: BoxDecoration(
          boxShadow: [
            configThemeShadow(),
          ],
          color: HzyColorConfig().colthemes,
          borderRadius: BorderRadius.all(
            Radius.circular(20.w),
          ),
        ),
        child: Text(
          "刷新",
          style:
              TextStyleMacor.fontMedium(16.sp, HzyColorConfig().colonlywhite),
        ),
      ),
    );
  }

  /// 触发方法
  ///
  ///

  /// 配置默认数据
  @override
  void configNormalData() {}

  Widget configplaceWidget({
    int type = 1,
  }) {
    Widget? child = Container();
    switch (type) {
      case 1:
        child = createPlaceImageWidget();
        break;
      case 2:
        child = createPlaceTitleWidget();
        break;
      case 3:
        child = createPlaceMessageWidget();
        break;
      case 4:
        child = createPlaceReloadBtnWidget();
        break;
      default:
    }
    return child;
  }
}
