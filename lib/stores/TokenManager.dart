import 'package:hm_shop/constants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  //返回持久化对象的实例对象
  Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  String _token = "";
  //初始化Token
  Future<void> init() async {
    final prefs = await _getInstance();
    _token = prefs.getString(GlobalConstants.TOKEN_KEY) ?? ""; //获取TOKEN
  }

  //设置Token
  Future<void> setToken(String val) async {
    final prefs = await _getInstance();
    await prefs.setString(GlobalConstants.TOKEN_KEY, val); //将Token写入磁盘
    _token = val;
  }

  //获取Token
  String getToken() {
    return _token;
  }

  //删除Token
  Future<void> removeToken() async {
    final prefs = await _getInstance();
    prefs.remove(GlobalConstants.TOKEN_KEY); //磁盘中的token
    _token = ""; //内存中的token
  }
}

final tokenManager = TokenManager();
