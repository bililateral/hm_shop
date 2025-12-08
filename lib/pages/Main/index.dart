import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm_shop/api/user.dart';
import 'package:hm_shop/pages/Cart/index.dart';
import 'package:hm_shop/pages/Category/index.dart';
import 'package:hm_shop/pages/Home/index.dart';
import 'package:hm_shop/pages/My/index.dart';
import 'package:hm_shop/stores/TokenManager.dart';
import 'package:hm_shop/stores/UserController.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //定义数据，根据数据渲染底部4个导航,一般App的导航是固定的
  final List<Map<String, String>> _tabList = [
    {
      "icon": "lib/assets/ic_public_home_normal.png", //正常显示的图标
      "active_icon": "lib/assets/ic_public_home_active.png", //点击状态下的图标
      "text": "首页",
    },
    {
      "icon": "lib/assets/ic_public_pro_normal.png", //正常显示的图标
      "active_icon": "lib/assets/ic_public_pro_active.png", //点击状态下的图标
      "text": "分类",
    },
    {
      "icon": "lib/assets/ic_public_cart_normal.png", //正常显示的图标
      "active_icon": "lib/assets/ic_public_cart_active.png", //点击状态下的图标
      "text": "购物车",
    },
    {
      "icon": "lib/assets/ic_public_my_normal.png", //正常显示的图标
      "active_icon": "lib/assets/ic_public_my_active.png", //点击状态下的图标
      "text": "我的",
    },
  ];
  int _currentIndex = 0;

  UserController _userController = Get.put(UserController());
  void _init() async {
    //要先确保token已经初始化，不然没法判断是否有token
    await tokenManager.init();
    if (tokenManager.getToken().isNotEmpty) {
      //如果有token就获取用户信息
      _userController.updateUserInfo(await getUserInfoAPI());
    }
  }

  @override
  void initState() {
    super.initState();
    //初始化用户
    _init();
  }

  List<BottomNavigationBarItem> _getTabBarWidget() {
    return List.generate(_tabList.length, (index) {
      return BottomNavigationBarItem(
        icon: Image.asset(_tabList[index]["icon"]!, height: 30, width: 30),
        activeIcon: Image.asset(
          _tabList[index]["active_icon"]!,
          height: 30,
          width: 30,
        ),
        label: _tabList[index]["text"],
      );
    });
  }

  List<Widget> _getChildren() {
    return [HomeView(), CategoryView(), CartView(), MineView()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //避开安全区组件
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _getChildren()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _currentIndex = value;
          setState(() {});
        },
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        items: _getTabBarWidget(),
        currentIndex: _currentIndex,
      ),
    );
  }
}
