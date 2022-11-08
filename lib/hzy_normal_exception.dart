/*
 * @Descripttion: 
 * @version: 
 * @Author: TT
 * @Date: 2022-11-08 10:28:04
 * @LastEditors: TT
 * @LastEditTime: 2022-11-08 15:58:39
 */

class HzyNormalExceeption {
  final String? _errmsg;
  String get msg => _errmsg ?? runtimeType.toString();
  final int? _code;
  int get code => _code ?? -1;
  HzyNormalExceeption([
    this._errmsg,
    this._code,
  ]);

  @override
  String toString() {
    return "code:$code--message=$msg";
  }
}

/// 客户端请求错误
class BadRequestException extends HzyNormalExceeption {
  BadRequestException({String? message, int? code}) : super(message, code);
}

/// 服务端响应错误
class BadServiceException extends HzyNormalExceeption {
  BadServiceException({String? message, int? code}) : super(message, code);
}

class UnknownException extends HzyNormalExceeption {
  UnknownException([String? message]) : super(message);
}

class CancelException extends HzyNormalExceeption {
  CancelException([String? message]) : super(message);
}

class NetworkException extends HzyNormalExceeption {
  NetworkException({String? message, int? code}) : super(message, code);
}

/// 401
class UnauthorisedException extends HzyNormalExceeption {
  UnauthorisedException({String? message, int? code = 401}) : super(message);
}

class BadResponseException extends HzyNormalExceeption {
  dynamic data;
  BadResponseException([this.data]) : super();
}
