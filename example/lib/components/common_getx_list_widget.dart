/*
 * @Description: 
 * @Version: 2.0
 * @Autor: ftt
 * @Date: 2022-06-09 11:20:18
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:30:36
 */

import 'package:hzy_normal_widget/hzy_normal_widget.dart';
import 'package:flutter/material.dart';
import '../config/dataconfig/hzy_color_config.dart';
import 'common_getx_controller.dart';
import 'common_place_holder_widget.dart';

abstract class CommonGetXlistWidget<T extends CommonGetXListController>
    extends NormalGetxListView<T> {
  CommonGetXlistWidget({Key? key}) : super(key: key);

  @override
  Color? get navbackcolor => HzyColorConfig().whitebackgroundColor;

  @override
  Color? get backgroundColor => HzyColorConfig().whitebackgroundColor;

  // 创建 列表 缺省页
  @override
  Widget? createEmptyWidget() {
    return controller.pageState.value == PageState.emptyDataState
        ? createErrorWidget()
        : null;
  }

  /// 创建整个界面失败页,具体怎么显示,取决于你的业务场景
  /// 创建失败 界面
  @override
  Widget? createErrorWidget() {
    return CommonPlaceHoldPage(
      placeHoldType: controller.placeHoldType,
      ontap: (value) {
        controller.configreload();
      },
    );
  }

  /// 通用创建列表的方法,使用者 需重写这个方法
  @override
  Widget createListView(BuildContext context) {
    throw UnimplementedError();
  }

  /// 通用创建列表item的方法,使用者可以根据习惯 选择性的使用
  @override
  Widget createListitem(BuildContext context, int index) {
    throw UnimplementedError();
  }

  @override
  Color? createLeadingIconColor() {
    return HzyColorConfig().col000000;
  }

  @override
  Color? createAppBarTextColor() {
    return HzyColorConfig().col000000;
  }

  @override
  Header? createHeader() {
    return ClassicalHeader(
      refreshingText: '正在刷新...',
      refreshedText: '刷新成功',
      refreshReadyText: '松开刷新',
      refreshFailedText: '刷新失败',
      refreshText: '下拉刷新',
      showInfo: false,
      textColor: HzyColorConfig().col000000,
    );
  }

  @override
  Footer? createFooter() {
    return ClassicalFooter(
        loadText: "上啦加载更多数据",
        loadReadyText: "松开加载",
        loadingText: "正在加载...",
        loadedText: "加载成功",
        loadFailedText: "加载失败",
        noMoreText: "没有更多数据了~",
        showInfo: false,
        textColor: HzyColorConfig().col000000);
  }
}
