//封装一个API，返回业务侧需要的内容
import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/utils/DioRequest.dart';
import 'package:hm_shop/viewmodels/home.dart';

Future<List<BannerItem>> getBannerListAPI() async {
  return ((await dioRequest.get(HttpConstants.BANNER_LIST)) as List).map((
    item,
  ) {
    return BannerItem.fromJSON(item as Map<String, dynamic>);
  }).toList();
}

Future<List<CategoryItem>> getCategoryListAPI() async {
  return ((await dioRequest.get(HttpConstants.CATEGORY_LIST)) as List).map((
    item,
  ) {
    return CategoryItem.fromJSON(item as Map<String, dynamic>);
  }).toList();
}

Future<SpecialRecommendResult> getProductListAPI() async {
  return SpecialRecommendResult.fromJSON(
    await dioRequest.get(HttpConstants.PRODUCT_LIST),
  );
}

Future<SpecialRecommendResult> getInVogueListAPI() async {
  return SpecialRecommendResult.fromJSON(
    await dioRequest.get(HttpConstants.IN_VOGUE_LIST),
  );
}

Future<SpecialRecommendResult> getOneStopListAPI() async {
  return SpecialRecommendResult.fromJSON(
    await dioRequest.get(HttpConstants.ONE_STOP_LIST),
  );
}

// 推荐列表
Future<List<GoodsDetailItem>> getRecommendListAPI(
  Map<String, dynamic> params,
) async {
  // 返回请求
  return ((await dioRequest.get(HttpConstants.RECOMMEND_LIST, params: params))
          as List)
      .map((item) {
        return GoodsDetailItem.formJSON(item as Map<String, dynamic>);
      })
      .toList();
}
