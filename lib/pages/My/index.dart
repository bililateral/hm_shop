import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm_shop/api/mine.dart';
import 'package:hm_shop/components/My/guessLike.dart';
import 'package:hm_shop/components/home/HmMoreList.dart';
import 'package:hm_shop/stores/TokenManager.dart';
import 'package:hm_shop/stores/UserController.dart';
import 'package:hm_shop/viewmodels/home.dart';
import 'package:hm_shop/viewmodels/user.dart';

class MineView extends StatefulWidget {
  const MineView({super.key});

  @override
  _MineViewState createState() => _MineViewState();
}

class _MineViewState extends State<MineView> {
  List<GoodsDetailItem> _list = [];
  final UserController _userController = Get.find(); //put共享数据
  //分页的请求参数
  Map<String, dynamic> _params = {"page": 1, "pageSize": 10};

  final ScrollController _controller = ScrollController();

  bool _isLoading = false;
  bool _hasMore = true;

  void _getGuessList() async {
    if (!_isLoading && _hasMore) {
      _isLoading = true;
      final res = await getGuessLikeAPI(_params);
      _isLoading = false;
      _list.addAll(res.items); //追加内容到尾部
      setState(() {});
      if (_params["page"] > res.page) {
        //没有下一页了
        _hasMore = false;
        return;
      }
      _params["page"]++; //页码加1
    }
  }

  void _registerEvent() {
    _controller.addListener(() {
      //滚动到底部时自动加载下一页内容
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 60) {
        _getGuessList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _registerEvent();
    _getGuessList();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('提示', textAlign: TextAlign.start),
        content: Text(
          '您确定要退出登录吗？',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context), //退出当前弹窗
                  child: Text('取消'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    //清除Getx  删除token
                    await tokenManager.removeToken();
                    _userController.updateUserInfo(UserInfo.fromJSON({}));
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text('确定'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getLogout() {
    return Expanded(
      flex: 1,
      child: TextButton(
        onPressed: () {
          _showLogoutDialog();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Text(
          '退出登录',
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 61, 60, 60),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFFFFF2E8), const Color(0xFFFDF6F1)],
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 40, top: 80, bottom: 20),
      child: Row(
        children: [
          Obx(() {
            return CircleAvatar(
              radius: 26,
              backgroundImage:
                  _userController
                      .user
                      .value
                      .avatar
                      .isNotEmpty //头像也要更新
                  ? NetworkImage(_userController.user.value.avatar)
                  : const AssetImage('lib/assets/goods_avatar.png'),
              backgroundColor: Colors.white,
            );
          }),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  //Obx中必须含有监测的响应式更新数据,要实现响应式更新必须用Obx()包裹
                  return GestureDetector(
                    onTap: () {
                      if (_userController.user.value.id.isEmpty) {
                        Navigator.pushNamed(context, "/login");
                      }
                    },
                    child: Text(
                      _userController.user.value.id.isNotEmpty
                          ? _userController.user.value.account
                          : '立即登录', //有登录信息则显示用户信息，否则显示立即登录
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis, // 文字过长时显示省略号
                    ),
                  );
                }),
              ],
            ),
          ),
          Obx(() {
            //必须用Obx包裹，不然登陆成功后不会立刻显示退出按钮，只有当再次返回我的页面触发整个页面的更新后才会显示退出按钮
            return _userController.user.value.account.isNotEmpty
                ? _getLogout()
                : SizedBox(width: 10, height: 10);
          }),
        ],
      ),
    );
  }

  Widget _buildVipCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 239, 197, 153),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Image.asset("lib/assets/ic_user_vip.png", width: 30, height: 30),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '升级美荟商城会员，尊享无限免邮',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(128, 44, 26, 1),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(126, 43, 26, 1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('立即开通', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    Widget item(String pic, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(pic, width: 30, height: 30, fit: BoxFit.cover),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            item("lib/assets/ic_user_collect.png", '我的收藏'),
            item("lib/assets/ic_user_history.png", '我的足迹'),
            item("lib/assets/ic_user_unevaluated.png", '我的客服'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderModule() {
    Widget orderItem(String pic, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(pic, width: 30, height: 30, fit: BoxFit.cover),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),

          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '我的订单',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  orderItem("lib/assets/ic_user_order.png", '全部订单'),
                  orderItem("lib/assets/ic_user_obligation.png", '待付款'),
                  orderItem("lib/assets/ic_user_unreceived.png", '待发货'),
                  orderItem("lib/assets/ic_user_unshipped.png", '待收货'),
                  orderItem("lib/assets/ic_user_unevaluated.png", '待评价'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildVipCard()),
        SliverToBoxAdapter(child: _buildQuickActions()),
        SliverToBoxAdapter(child: _buildOrderModule()),
        //pinned: true表示吸住
        SliverPersistentHeader(delegate: GuessLike(), pinned: true), // 猜你喜欢
        HmMoreList(recommendList: _list),
      ],
    );
  }
}
