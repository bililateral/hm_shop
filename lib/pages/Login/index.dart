import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm_shop/api/user.dart';
import 'package:hm_shop/stores/TokenManager.dart';
import 'package:hm_shop/stores/UserController.dart';
import 'package:hm_shop/utils/LoadingDialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneController = TextEditingController(); // 账号控制器
  TextEditingController _codeController = TextEditingController(); // 密码控制器
  UserController _userController = Get.find();

  // 用户账号Widget
  Widget _buildPhoneTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "手机号不能为空";
        }
        //校验手机号格式
        if (!RegExp(r"1[3-9]\d{9}$").hasMatch(value)) {
          return "手机号格式不正确，请重新输入";
        }
        return null;
      },
      controller: _phoneController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20), // 内容内边距
        hintText: "请输入账号",
        fillColor: const Color.fromRGBO(243, 243, 243, 1),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  // 用户密码Widget
  Widget _buildCodeTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "密码不能为空";
        }
        //限制密码是6-16位的数字 字母 下划线
        if (!RegExp(r"^[a-zA-Z0-9_]{6,16}$").hasMatch(value)) {
          return "密码格式不正确，请输入6-16位数字、字母或下划线";
        }
        return null;
      },
      controller: _codeController,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20), // 内容内边距
        hintText: "请输入密码",
        fillColor: const Color.fromRGBO(243, 243, 243, 1),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  //测试账号：13200000001~13200000010
  //密码：123456
  void _login() async {
    try {
      LoadingDialog.show(context, message: "正在登录,请稍候"); //显示登录加载弹窗
      final res = await loginAPI({
        "account": _phoneController.text,
        "password": _codeController.text,
      });
      _userController.updateUserInfo(res); //登录时更新共享数据信息
      tokenManager.setToken(res.token); //设置token持久化
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 180,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(40),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          content: Text("登录成功", textAlign: TextAlign.center),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 180,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(40),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          content: Text(
            (e as DioException).toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  static bool showLoading = false; //防止同时出现多个未勾选提示框消息
  // 登录按钮Widget
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // 登录逻辑
          //要有这个_globalKey，前面的账号、密码输入框才会有验证信息提示
          if (_globalKey.currentState!.validate()) {
            //校验勾选框是否勾选
            if (!_isChecked) {
              if (!_LoginPageState.showLoading) {
                showLoading = true;
                Future.delayed(Duration(seconds: 2), () {
                  showLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    width: 180,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(40),
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                    content: Text("请勾选用户协议", textAlign: TextAlign.center),
                  ),
                );
              }
            } else {
              _login();
            }
          }
          //Navigator.pushNamed(context, "/");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text("登录", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  bool _isChecked = false;
  // 勾选Widget
  Widget _buildCheckbox() {
    return Row(
      children: [
        // 设置勾选为圆角
        Checkbox(
          value: _isChecked,
          activeColor: Colors.black,
          checkColor: Colors.white,
          onChanged: (bool? value) {
            _isChecked = value ?? false;
            setState(() {});
          },
          // 设置形状
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 圆角大小
          ),
          // 可选：设置边框
          side: BorderSide(color: Colors.grey, width: 2.0),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "查看并同意"),
              TextSpan(
                text: "《隐私条款》",
                style: TextStyle(color: Colors.blue),
              ),
              TextSpan(text: "和"),
              TextSpan(
                text: "《用户协议》",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 头部Widget
  Widget _buildHeader() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "账号密码登录",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  final GlobalKey<FormState> _globalKey =
      GlobalKey<FormState>(); //创建一个GlobalKey用于调用Form表单的validate方法校验账号密码输入的正确性
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("惠多美登录", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _globalKey,
        child: Container(
          padding: EdgeInsets.all(30),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildHeader(),
              SizedBox(height: 30),
              _buildPhoneTextField(),
              SizedBox(height: 20),
              _buildCodeTextField(),
              SizedBox(height: 20),
              _buildCheckbox(),
              SizedBox(height: 20),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
