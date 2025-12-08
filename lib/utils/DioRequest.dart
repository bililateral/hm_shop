import 'package:dio/dio.dart';
import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/stores/TokenManager.dart';

void main(List<String> args) {}

class DioRequest {
  final Dio _dio = Dio();
  DioRequest() {
    // _dio.options.baseUrl = "https://geek.itheima.net/v1_0/";
    // _dio.options.connectTimeout = Duration(seconds: 10); //连接超时
    // _dio.options.sendTimeout = Duration(seconds: 10); //发送超时
    // _dio.options.receiveTimeout = Duration(seconds: 10); //接收超时
    //简写
    _dio.options
      ..baseUrl = GlobalConstants.BASE_URL
      ..connectTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
      ..sendTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
      ..receiveTimeout = Duration(seconds: GlobalConstants.TIME_OUT);
    //拦截器
    _addInterceptor();
  }

  void _addInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        //请求拦截器
        onRequest: (options, handler) {
          //options就是request
          //放行之前注入token request headers Authorization ="Bear token"(一般遵循的token格式)
          if (tokenManager.getToken().isNotEmpty) {
            options.headers = {
              "Authorization": "Bearer ${tokenManager.getToken()}",
            };
          }
          handler.next(options); //放过请求
          //handler.reject(error); //拦截请求
        },
        //响应拦截器
        onResponse: (response, handler) {
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            handler.next(response);
            return;
          }
          handler.reject(DioException(requestOptions: response.requestOptions));
        },
        //错误拦截器
        onError: (error, handler) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              message: error.response?.data["msg"] ?? "异常信息",
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? params}) {
    return _handleResponse(_dio.get(url, queryParameters: params));
  }

  //定义Post接口
  Future<dynamic> post(String url, {Map<String, dynamic>? data}) {
    return _handleResponse(_dio.post(url, data: data));
  }

  //进一步处理返回结果的函数
  Future<dynamic> _handleResponse(Future<Response<dynamic>> task) async {
    try {
      Response<dynamic> res = await task;
      final data = res.data as Map<String, dynamic>;
      //业务认证码成功而且HTTP状态码正常
      if (data["code"] == GlobalConstants.SUCCESS_CODE) {
        return data["result"];
      }
      throw DioException(
        requestOptions: res.requestOptions,
        message: data["msg"] ?? "加载数据异常",
      );
    } catch (e) {
      rethrow; //保持原始异常类型(如：拦截器抛出的DioException)，不再重新包裹成通用异常
    }
  }
}

final dioRequest = DioRequest();

//dio工具发出的请求返回的数据存在Response<dynamic>.data中
//把所有接口的data解放出来 拿到真正的数据  要判断业务状态码是不是等于1
