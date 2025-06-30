# hzy_normal_network

火之夜网络请求封装库 - 基于 Dio 的 Flutter 网络请求解决方案

## 简介

`hzy_normal_network` 是一个基于 [Dio](https://pub.dev/packages/dio) 的 Flutter 网络请求封装库，提供了简洁易用的 API 和统一的响应处理机制。该库旨在简化网络请求的使用，提供更好的错误处理和响应转换功能。

## 特性

- 🚀 基于 Dio 的高性能网络请求
- 📦 统一的响应数据格式
- 🛡️ 完善的异常处理机制
- 🔧 灵活的配置选项
- 📝 支持请求/响应日志
- 🎯 支持自定义数据转换器
- ⚡ 支持请求拦截器
- 🔄 支持请求取消
- 📊 支持上传/下载进度监听

## 安装

在 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  hzy_normal_network: ^0.0.2
```

然后运行：

```bash
flutter pub get
```

## 快速开始

### 基本使用

```dart
import 'package:hzy_normal_network/hzy_normal_network.dart';

// 创建网络客户端
final client = HzyNormalClient(
  normalHttpConfig: HzyNormalHttpConfig(
    baseUrl: 'https://api.example.com',
    isNeedLog: true,
    connectTimeout: 30,
    sendTimeout: 30,
    receiveTimeout: 30,
  ),
);

// GET 请求
final response = await client.get(
  url: '/users',
  queryParameters: {'page': 1, 'limit': 10},
);

if (response.ok) {
  print('请求成功: ${response.data}');
} else {
  print('请求失败: ${response.msg}');
}

// POST 请求
final postResponse = await client.post(
  '/users',
  data: {
    'name': 'John Doe',
    'email': 'john@example.com',
  },
);
```

### 配置选项

```dart
final config = HzyNormalHttpConfig(
  baseUrl: 'https://api.example.com',
  contentType: 'application/json',
  headers: {
    'Authorization': 'Bearer your-token',
    'Accept': 'application/json',
  },
  isNeedLog: true,
  connectTimeout: 30,
  sendTimeout: 30,
  receiveTimeout: 30,
  caCheStatusCode: 304,
  interceptors: [
    // 添加自定义拦截器
  ],
);

final client = HzyNormalClient(normalHttpConfig: config);
```

### 自定义数据转换器

```dart
class CustomTransformer extends HzyNormalTransFormer {
  @override
  HzyNormalResponse parse(Response response) {
    final data = response.data;
    // 自定义解析逻辑
    if (data['success'] == true) {
      return HzyNormalResponse.success(
        netData: data['result'],
        reqMsg: data['message'] ?? '请求成功',
      );
    } else {
      return HzyNormalResponse.fail(
        data: data,
        errorMsg: data['message'] ?? '请求失败',
        errorCode: data['code'] ?? -1,
      );
    }
  }
}

// 使用自定义转换器
final response = await client.get(
  url: '/data',
  httpTransformer: CustomTransformer(),
);
```

### 错误处理

```dart
final response = await client.get(url: '/api/data');

if (response.ok) {
  // 请求成功
  final data = response.data;
  print('数据: $data');
} else {
  // 请求失败
  final error = response.error;
  print('错误代码: ${error?.code}');
  print('错误信息: ${error?.msg}');
  
  // 根据错误类型处理
  if (error is UnauthorisedException) {
    // 处理未授权错误
  } else if (error is BadRequestException) {
    // 处理客户端请求错误
  } else if (error is BadServiceException) {
    // 处理服务端错误
  }
}
```

### 请求取消

```dart
final cancelToken = CancelToken();

// 发起请求
final responseFuture = client.get(
  url: '/long-running-request',
  cancelToken: cancelToken,
);

// 取消请求
cancelToken.cancel('用户取消了请求');
```

### 上传进度监听

```dart
final response = await client.post(
  '/upload',
  data: FormData.fromMap({
    'file': await MultipartFile.fromFile('/path/to/file'),
  }),
  onSendProgress: (sent, total) {
    final progress = (sent / total * 100).toStringAsFixed(1);
    print('上传进度: $progress%');
  },
);
```

## API 文档

### HzyNormalClient

主要的网络请求客户端类。

#### 构造函数

```dart
HzyNormalClient({
  BaseOptions? options,
  HzyNormalHttpConfig? normalHttpConfig,
})
```

#### 方法

- `get()` - GET 请求
- `post()` - POST 请求
- `put()` - PUT 请求
- `patch()` - PATCH 请求
- `delete()` - DELETE 请求
- `download()` - 文件下载
- `upload()` - 文件上传

### HzyNormalHttpConfig

网络请求配置类。

```dart
HzyNormalHttpConfig({
  String? baseUrl,                    // 基础 URL
  String? contentType,                // 内容类型
  Map<String, dynamic>? headers,     // 请求头
  List<Interceptor>? interceptors,    // 拦截器列表
  bool isNeedLog = true,              // 是否需要日志
  int connectTimeout = 30,            // 连接超时时间（秒）
  int sendTimeout = 30,               // 发送超时时间（秒）
  int receiveTimeout = 30,            // 接收超时时间（秒）
  int caCheStatusCode = 304,          // 缓存状态码
})
```

### HzyNormalResponse

统一的响应数据格式。

```dart
class HzyNormalResponse {
  bool ok;                           // 请求是否成功
  dynamic data;                      // 响应数据
  String msg;                        // 响应消息
  HzyNormalExceeption? error;        // 错误信息
  Map<String, dynamic>? response;    // 原始响应
}
```

### 异常类型

- `HzyNormalExceeption` - 基础异常类
- `BadRequestException` - 客户端请求错误（4xx）
- `BadServiceException` - 服务端响应错误（5xx）
- `UnauthorisedException` - 未授权异常（401）
- `UnknownException` - 未知异常
- `CancelException` - 请求取消异常
- `BadResponseException` - 响应格式错误异常

## 最佳实践

### 1. 全局配置

建议在应用启动时创建全局的网络客户端实例：

```dart
class NetworkManager {
  static late HzyNormalClient _client;
  
  static void init() {
    _client = HzyNormalClient(
      normalHttpConfig: HzyNormalHttpConfig(
        baseUrl: 'https://api.yourapp.com',
        isNeedLog: kDebugMode,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }
  
  static HzyNormalClient get client => _client;
}
```

### 2. 统一错误处理

```dart
class ApiService {
  static Future<T?> request<T>(
    Future<HzyNormalResponse> Function() request,
    T Function(dynamic data) parser,
  ) async {
    try {
      final response = await request();
      if (response.ok) {
        return parser(response.data);
      } else {
        _handleError(response.error);
        return null;
      }
    } catch (e) {
      print('请求异常: $e');
      return null;
    }
  }
  
  static void _handleError(HzyNormalExceeption? error) {
    // 统一错误处理逻辑
  }
}
```

### 3. 数据模型转换

```dart
class User {
  final int id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// 使用
final response = await client.get(url: '/user/1');
if (response.ok) {
  final user = User.fromJson(response.data);
}
```

## 更新日志

### 0.0.2
- 优化错误处理机制
- 添加更多异常类型
- 改进日志输出
- 更新依赖版本

### 0.0.1
- 初始版本发布
- 基础网络请求功能
- 统一响应处理
- 自定义转换器支持

## 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目。

## 许可证

本项目采用 MIT 许可证。详情请查看 [LICENSE](LICENSE) 文件。

## 联系方式

- 项目地址: [https://gitee.com/tengteng_fan/hzy_normal_network.git](https://gitee.com/tengteng_fan/hzy_normal_network.git)
- 问题反馈: 请在 Gitee 上提交 Issue

---

如果这个库对你有帮助，请给个 ⭐️ 支持一下！
