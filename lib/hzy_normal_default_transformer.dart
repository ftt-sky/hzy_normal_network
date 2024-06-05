/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:50:41
 * @LastEditors: TT-hzy 
 * @LastEditTime: 2024-06-05 15:09:36
 */
import 'package:dio/dio.dart';
import 'package:hzy_normal_network/hzy_normal_response.dart';
import 'package:hzy_normal_network/hzy_normal_transformer.dart';

///Http配置.
class HzyNormalHttpResponeConfig {
  /// constructor.
  HzyNormalHttpResponeConfig({
    this.status,
    this.code,
    this.msg,
    this.data,
    this.successCode,
  });

  /// BaseResp [String status]字段 key, 默认：status.
  String? status;

  /// BaseResp [int code]字段 key, 默认：errorCode.
  String? code;

  /// BaseResp [String msg]字段 key, 默认：errorMsg.
  String? msg;

  /// BaseResp [T data]字段 key, 默认：data.
  String? data;

  /// 判断请求成功的值
  int? successCode;
}

class HzyNormalDefaultTransFormer extends HzyNormalTransFormer {
  String _statusKey = 'status';
  String _codeKey = "code";
  String _msgKey = 'msg';
  String _dataKey = "data";
  int _successCode = 1;

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
    var status = json[_statusKey];
    int code = 0;
    if (status is bool) {
      if (status) {
        code = 1;
      }
    } else {
      if (status == _successCode) {
        code = 1;
      }
    }
    if (code == 1) {
      return HzyNormalResponse.success(
        netData: json[_dataKey],
        response: json,
        reqMsg: json[_msgKey],
      );
    }
    return HzyNormalResponse.fail(
      errorMsg: (json[_msgKey] != null) ? json[_msgKey] : "",
      errorCode: code,
      data: json[_dataKey] ?? json,
    );
  }

  ///
  setHttpConfig({
    required HzyNormalHttpResponeConfig config,
  }) {
    _statusKey = config.status ?? _statusKey;
    _dataKey = config.data ?? _dataKey;
    _msgKey = config.msg ?? _msgKey;
    _codeKey = config.code ?? _codeKey;
    _successCode = config.successCode ?? _successCode;
  }

  /// 单例对象
  static final HzyNormalDefaultTransFormer _instance =
      HzyNormalDefaultTransFormer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  HzyNormalDefaultTransFormer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory HzyNormalDefaultTransFormer.getInstance() => _instance;
}
