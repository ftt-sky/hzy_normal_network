/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:50:41
 * @LastEditors: TT
 * @LastEditTime: 2022-11-28 22:23:25
 */
import 'package:dio/dio.dart';
import 'package:hzy_normal_network/hzy_normal_response.dart';
import 'package:hzy_normal_network/hzy_normal_transformer.dart';

///Http配置.
class HzyNormalHttpResponeConfig {
  /// constructor.
  HzyNormalHttpResponeConfig(
      {this.status, this.code, this.msg, this.data, this.successcode});

  /// BaseResp [String status]字段 key, 默认：status.
  String? status;

  /// BaseResp [int code]字段 key, 默认：errorCode.
  String? code;

  /// BaseResp [String msg]字段 key, 默认：errorMsg.
  String? msg;

  /// BaseResp [T data]字段 key, 默认：data.
  String? data;

  /// 判断请求成功的值
  int? successcode;
}

class HzyNormalDefaultTransFormer extends HzyNormalTransFormer {
  String _statuskey = 'status';
  String _codekey = "code";
  String _msgkey = 'msg';
  String _datakey = "data";
  int _successcode = 1;

  @override
  HzyNormalResponse parse(Response response) {
    var json = response.data as Map<String, dynamic>?;
    if (json == null) {
      return HzyNormalResponse.fail(
        data: json,
        errorMsg: '请求的数据为空',
        errorCode: -1,
      );
    }
    var status = json[_statuskey];
    int code = 0;
    if (status is bool) {
      if (status) {
        code = 1;
      }
    } else {
      if (status == _successcode) {
        code = 1;
      }
    }
    if (code == 1) {
      return HzyNormalResponse.success(
        netdata: json[_datakey],
        response: json,
        reqmsg: json[_msgkey],
      );
    }
    return HzyNormalResponse.fail(
      errorMsg: (json[_msgkey] != null) ? json[_msgkey] : "",
      errorCode: code,
      data: json[_datakey] ?? json,
    );
  }

  ///
  setHttpConfig({
    required HzyNormalHttpResponeConfig config,
  }) {
    _statuskey = config.status ?? _statuskey;
    _datakey = config.data ?? _datakey;
    _msgkey = config.msg ?? _msgkey;
    _codekey = config.code ?? _codekey;
    _successcode = config.successcode ?? _successcode;
  }

  /// 单例对象
  static final HzyNormalDefaultTransFormer _instance =
      HzyNormalDefaultTransFormer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  HzyNormalDefaultTransFormer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory HzyNormalDefaultTransFormer.getInstance() => _instance;
}
