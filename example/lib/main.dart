/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:03:17
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 11:29:42
 */
import 'package:flutter/material.dart';

import 'config/dataconfig/global_config.dart';
import 'init/application.dart';

void main() {
  init();
}

void init() async {
  await GlobalConfig.init();
  runApp(Application());
}
