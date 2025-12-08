import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/utils/DioRequest.dart';
import 'package:hm_shop/viewmodels/home.dart';

Future<GoodsDetailItems> getGuessLikeAPI(Map<String, dynamic> params) async {
  return GoodsDetailItems.fromJSON(
    await dioRequest.get(HttpConstants.GUESS_LIKE, params: params),
  );
}
