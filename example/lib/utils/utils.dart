/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-10-31 22:46:42
 * @LastEditors: TT
 * @LastEditTime: 2022-11-02 21:55:52
 */

import 'package:flutter_easyloading/flutter_easyloading.dart';

/*
 * @name: 通用加载动画
 * @param {*}
 * @return {*}
 */
void showLoading() {
  EasyLoading.show();
}

/*
 * @name: 动画消失
 * @param {*}
 * @return {*}
 */
void loadingdismiss() {
  EasyLoading.dismiss();
}
