import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hzy_normal_network/hzy_normal_network.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HzyNormalNetwork Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NetworkExamplePage(),
    );
  }
}

class NetworkExamplePage extends StatefulWidget {
  const NetworkExamplePage({super.key});

  @override
  State<NetworkExamplePage> createState() => _NetworkExamplePageState();
}

class _NetworkExamplePageState extends State<NetworkExamplePage> {
  late HzyNormalClient _client;
  String _result = '点击按钮开始网络请求';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initNetworkClient();
  }

  /// 初始化网络客户端
  void _initNetworkClient() {
    _client = HzyNormalClient(
      normalHttpConfig: HzyNormalHttpConfig(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        isNeedLog: true,
        connectTimeout: 30,
        sendTimeout: 30,
        receiveTimeout: 30,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  /// 执行 GET 请求示例
  Future<void> _performGetRequest() async {
    setState(() {
      _loading = true;
      _result = '正在请求数据...';
    });

    try {
      final response = await _client.get(
        url: '/posts/1',
      );

      setState(() {
        _loading = false;
        if (response.ok) {
          _result = '请求成功！\n\n数据：\n${response.data}';
        } else {
          _result = '请求失败：${response.msg}\n错误代码：${response.error?.code}';
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _result = '请求异常：$e';
      });
    }
  }

  /// 执行 POST 请求示例
  Future<void> _performPostRequest() async {
    setState(() {
      _loading = true;
      _result = '正在发送数据...';
    });

    try {
      final response = await _client.post(
        '/posts',
        data: {
          'title': 'HzyNormalNetwork 测试',
          'body': '这是一个使用 HzyNormalNetwork 的 POST 请求示例',
          'userId': 1,
        },
      );

      setState(() {
        _loading = false;
        if (response.ok) {
          _result = 'POST 请求成功！\n\n响应数据：\n${response.data}';
        } else {
          _result = 'POST 请求失败：${response.msg}\n错误代码：${response.error?.code}';
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _result = 'POST 请求异常：$e';
      });
    }
  }

  /// 执行带自定义转换器的请求
  Future<void> _performRequestWithCustomTransformer() async {
    setState(() {
      _loading = true;
      _result = '使用自定义转换器请求数据...';
    });

    try {
      final response = await _client.get(
        url: '/users',
        httpTransformer: CustomTransformer(),
      );

      setState(() {
        _loading = false;
        if (response.ok) {
          _result = '自定义转换器请求成功！\n\n用户数量：${(response.data as List).length}';
        } else {
          _result = '自定义转换器请求失败：${response.msg}';
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _result = '自定义转换器请求异常：$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HzyNormalNetwork 示例'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'HzyNormalNetwork 使用示例',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _performGetRequest,
              child: const Text('GET 请求示例'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading ? null : _performPostRequest,
              child: const Text('POST 请求示例'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading ? null : _performRequestWithCustomTransformer,
              child: const Text('自定义转换器示例'),
            ),
            const SizedBox(height: 20),
            const Text(
              '请求结果：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 自定义数据转换器示例
class CustomTransformer extends HzyNormalTransFormer {
  @override
  HzyNormalResponse parse(Response response) {
    // 自定义解析逻辑
    final data = response.data;

    if (response.statusCode == 200) {
      return HzyNormalResponse.success(
        netData: data,
        reqMsg: '自定义转换器解析成功',
      );
    } else {
      return HzyNormalResponse.fail(
        data: data,
        errorMsg: '自定义转换器解析失败',
        errorCode: response.statusCode,
      );
    }
  }
}

/// 网络管理器示例 - 全局单例模式
class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance => _instance ??= NetworkManager._();

  NetworkManager._();

  late final HzyNormalClient _client;

  /// 初始化网络管理器
  void init({
    required String baseUrl,
    Map<String, dynamic>? headers,
    bool isNeedLog = true,
  }) {
    _client = HzyNormalClient(
      normalHttpConfig: HzyNormalHttpConfig(
        baseUrl: baseUrl,
        headers: headers,
        isNeedLog: isNeedLog,
        connectTimeout: 30,
        sendTimeout: 30,
        receiveTimeout: 30,
      ),
    );
  }

  /// 获取网络客户端
  HzyNormalClient get client => _client;

  /// 通用请求方法
  Future<T?> request<T>(
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
      if (kDebugMode) {
        print('网络请求异常: $e');
      }
      return null;
    }
  }

  /// 统一错误处理
  void _handleError(HzyNormalExceeption? error) {
    if (error != null) {
      if (kDebugMode) {
        print('网络请求错误: ${error.msg} (${error.code})');
      }

      // 根据错误类型进行不同处理
      if (error is UnauthorisedException) {
        // 处理未授权错误，如跳转到登录页
        if (kDebugMode) {
          print('用户未授权，需要重新登录');
        }
      } else if (error is BadRequestException) {
        // 处理客户端请求错误
        if (kDebugMode) {
          print('请求参数错误');
        }
      } else if (error is BadServiceException) {
        // 处理服务端错误
        if (kDebugMode) {
          print('服务器内部错误');
        }
      }
    }
  }
}

/// 用户数据模型示例
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  /// 从 JSON 创建用户对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

/// API 服务示例
class ApiService {
  static final _networkManager = NetworkManager.instance;

  /// 获取用户列表
  static Future<List<User>?> getUsers() async {
    return _networkManager.request<List<User>>(
      () => _networkManager.client.get(url: '/users'),
      (data) => (data as List).map((json) => User.fromJson(json)).toList(),
    );
  }

  /// 获取单个用户
  static Future<User?> getUser(int userId) async {
    return _networkManager.request<User>(
      () => _networkManager.client.get(url: '/users/$userId'),
      (data) => User.fromJson(data),
    );
  }

  /// 创建用户
  static Future<User?> createUser(User user) async {
    return _networkManager.request<User>(
      () => _networkManager.client.post(
        '/users',
        data: user.toJson(),
      ),
      (data) => User.fromJson(data),
    );
  }

  /// 更新用户
  static Future<User?> updateUser(User user) async {
    return _networkManager.request<User>(
      () => _networkManager.client.put(
        '/users/${user.id}',
        data: user.toJson(),
      ),
      (data) => User.fromJson(data),
    );
  }

  /// 删除用户
  static Future<bool> deleteUser(int userId) async {
    final result = await _networkManager.request<bool>(
      () => _networkManager.client.delete('/users/$userId'),
      (data) => true,
    );
    return result ?? false;
  }
}
