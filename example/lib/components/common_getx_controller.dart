/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 11:22:44
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:22:45
 */
/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-29 10:37:14
 * @LastEditors: TT
 * @LastEditTime: 2022-10-31 18:02:38
 */
/*
 * @Description: 
 * @Version: 2.0
 * @Autor: ftt
 * @Date: 2022-06-09 11:38:22
 * @LastEditors: TT
 * @LastEditTime: 2022-08-05 15:15:23
 */

import 'package:hzy_normal_widget/hzy_normal_widget.dart';
import 'common_place_holder_widget.dart';

abstract class CommonGetXController extends NormalGetxController {
  /// 项目中 使用的失败界面的标识,用于使用者 显示不同的界面
  /// 具体 使用,一般是通过网络请求,进行逻辑处理
  var placeHoldType = CommonPlaceHoldType.nothing;
}

abstract class CommonGetXListController extends NormalGetxListController {
  /// 项目中 使用的失败界面的标识,用于使用者 显示不同的界面
  /// 具体 使用,一般是通过网络请求,进行逻辑处理
  var placeHoldType = CommonPlaceHoldType.nothing;

  @override
  configreload() {}

  configPageState({
    required int allNum,
    required int netlistNum,
  }) {
    PageState st = PageState.dataFetchState;
    if (allNum == 0) {
      st = PageState.emptyDataState;
    } else if (netlistNum == 0) {
      st = PageState.noMoreDataState;
    }
    return st;
  }
}
