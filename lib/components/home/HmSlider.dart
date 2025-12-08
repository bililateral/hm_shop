import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hm_shop/viewmodels/home.dart';

class HmSlider extends StatefulWidget {
  final List<BannerItem> bannerList;
  const HmSlider({super.key, required this.bannerList});

  @override
  State<HmSlider> createState() => _HmSliderState();
}

class _HmSliderState extends State<HmSlider> {
  final CarouselSliderController _controller =
      CarouselSliderController(); //控制轮播图跳转的控制器
  int _currentIndex = 0;
  Widget _getSearch() {
    return Positioned(
      top: 10,
      left: 10,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.4),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            "搜索...",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _getSlider() {
    //在flutter中获取屏幕宽度的方法
    final double screenWidth = MediaQuery.of(context).size.width;
    //返回轮播图插件
    //根据数据渲染的不同轮播选项
    return CarouselSlider(
      carouselController: _controller, //绑定controller对象，实现点击指示灯时切换
      items: List.generate(widget.bannerList.length, (index) {
        return Image.network(
          widget.bannerList[index].imgUrl,
          fit: BoxFit.cover,
          width: screenWidth,
        );
      }),
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          _currentIndex = index;
          setState(() {});
        },
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 2),
      ),
    );
  }

  //返回指示灯导航部件
  Widget _getDots() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.bannerList.length, (index) {
            return GestureDetector(
              onTap: () {
                _controller.jumpToPage(index);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                height: 6,
                width: _currentIndex == index ? 40 : 20,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? Colors.white
                      : Color.fromRGBO(0, 0, 0, 0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
                margin: EdgeInsets.symmetric(horizontal: 4),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //stack ->搜索框 轮播图 指示灯导航
    return Stack(children: [_getSlider(), _getSearch(), _getDots()]);
  }
}
