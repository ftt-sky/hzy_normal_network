/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:28:04
 * @LastEditors: TT-hzy 
 * @LastEditTime: 2024-06-06 15:00:01
 */

class HzyNormalExceeption {
  final String? _errMsg;
  String get msg => _errMsg ?? runtimeType.toString();
  final int? _code;
  int get code => _code ?? -1;
  HzyNormalExceeption([
    this._errMsg,
    this._code,
  ]);

  @override
  String toString() {
    return "code:$code--message=$msg";
  }
}

/// 客户端请求错误
class BadRequestException extends HzyNormalExceeption {
  BadRequestException({
    String? message,
    int? code,
  }) : super(message, code);
}

/// 服务端响应错误
class BadServiceException extends HzyNormalExceeption {
  BadServiceException({
    String? message,
    int? code,
  }) : super(message, code);
}

class UnknownException extends HzyNormalExceeption {
  UnknownException([
    super.message,
  ]);
}

class CancelException extends HzyNormalExceeption {
  CancelException([
    super.message,
  ]);
}

class NetworkException extends HzyNormalExceeption {
  NetworkException({
    String? message,
    int? code,
  }) : super(message, code);
}

/// 401
class UnauthorisedException extends HzyNormalExceeption {
  dynamic data;
  UnauthorisedException({
    String? message,
    int? code = 401,
    this.data,
  }) : super(message);
}

class BadResponseException extends HzyNormalExceeption {
  dynamic data;
  BadResponseException([
    this.data,
  ]) : super();
}
