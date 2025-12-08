import 'package:flutter/material.dart';
import 'package:hm_shop/api/home.dart';
import 'package:hm_shop/components/home/HmCategory.dart';
import 'package:hm_shop/components/home/HmHot.dart';
import 'package:hm_shop/components/home/HmMoreList.dart';
import 'package:hm_shop/components/home/HmSlider.dart';
import 'package:hm_shop/components/home/HmSuggestion.dart';
import 'package:hm_shop/viewmodels/home.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<BannerItem> _bannerList = [
    BannerItem(
      id: "1",
      imgUrl: "https://img95.699pic.com/photo/50005/8551.jpg_wh860.jpg",
    ),
    BannerItem(
      id: "2",
      imgUrl:
          "https://bpic.588ku.com/back_origin_min_pic/21/03/30/251617b5c1ad3b0c7ae62fb8b51dfbbd.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    ),
    BannerItem(
      id: "3",
      imgUrl: "https://img95.699pic.com/photo/60021/4053.jpg_wh860.jpg",
    ),
  ];

  List<CategoryItem> _categoryList = [];
  SpecialRecommendResult _specialRecommendResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );

  SpecialRecommendResult _inVogueResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );

  SpecialRecommendResult _oneStopResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );

  // 推荐列表
  List<GoodsDetailItem> _recommendList = [];

  //获取滚动容器的内容
  List<Widget> _getScrollChildren() {
    return [
      SliverToBoxAdapter(child: HmSlider(bannerList: _bannerList)), //轮播图组件
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      //SliverGrid和SliverList只能纵向,所以这里只能用SliverToBoxAdapter包装的ListView
      SliverToBoxAdapter(child: HmCategory(categoryList: _categoryList)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: HmSuggestion(specialRecommendResult: _specialRecommendResult),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: HmHot(result: _inVogueResult, type: "hot"),
              ),
              SizedBox(width: 10),
              Expanded(
                child: HmHot(result: _oneStopResult, type: "step"),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      HmMoreList(recommendList: _recommendList), // 无限滚动列表
    ];
  }

  //获取轮播图
  Future<void> _getBannerList() async {
    _bannerList = await getBannerListAPI();
    setState(() {});
  }

  //获取分类列表
  Future<void> _getCategoryList() async {
    _categoryList = await getCategoryListAPI();
    setState(() {});
  }

  //获取特惠推荐数据
  Future<void> _getProductList() async {
    _specialRecommendResult = await getProductListAPI();
    setState(() {});
  }

  //获取热榜推荐列表
  Future<void> _getInVogueList() async {
    _inVogueResult = await getInVogueListAPI();
    setState(() {});
  }

  //获取一站式推荐列表
  Future<void> _getOnStopList() async {
    _oneStopResult = await getOneStopListAPI();
    setState(() {});
  }

  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  // 获取推荐列表(接口已更换，无法获取推荐列表数据)  实现上拉加载
  Future<void> _getRecommendList() async {
    if (!_isLoading && _hasMore) {
      try {
        _isLoading = true;
        int requestLimit = _page * 10;
        _recommendList = await getRecommendListAPI({"limit": requestLimit});
        _isLoading = false;
        setState(() {});
        if (_recommendList.length < requestLimit) {
          _hasMore = false;
          return;
        }
        _page++;
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("推荐下拉列表接口请求失败:$e,请稍后重试或更换请求接口")));
      }
    }
  }

  void _registerEvent() {
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 40) {
        //滚动到底部加载下一页数据
        _getRecommendList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getBannerList();
    _getCategoryList();
    _getProductList();
    _getInVogueList();
    _getOnStopList();
    _getRecommendList();
    _registerEvent();
  }

  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    //定义RefreshIndicator组件，实现主页下拉刷新的功能
    return RefreshIndicator(
      onRefresh: () async {
        _page = 1;
        _isLoading = false;
        _hasMore = true;
        await _getBannerList();
        await _getCategoryList();
        await _getProductList();
        await _getInVogueList();
        await _getOnStopList();
        await _getRecommendList();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: 120,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(40),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text("下拉刷新成功", textAlign: TextAlign.center),
          ),
        );
      },
      child: CustomScrollView(
        controller: _controller,
        slivers: _getScrollChildren(), //内容必须是sliver家族的
      ),
    );
  }
}
