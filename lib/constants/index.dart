class GlobalConstants {
  static const String BASE_URL = "https://meikou-api.itheima.net"; //访问不了
  static const int TIME_OUT = 10;
  static const String SUCCESS_CODE = "1";
  static const String TOKEN_KEY = "hm_shop_token"; //Token对应的持久化的key
}

//存放请求地址接口的常量
class HttpConstants {
  static const String BANNER_LIST = "/home/banner";
  static const String CATEGORY_LIST = "/home/category/head";
  static const String PRODUCT_LIST = "/hot/preference"; //特惠推荐请求地址
  static const String IN_VOGUE_LIST = "/hot/inVogue"; //热榜推荐请求地址
  static const String ONE_STOP_LIST = "/hot/oneStop"; //一站式推荐请求地址
  static const String RECOMMEND_LIST = "/hot/recommend"; //主页下拉列表请求地址(无法正常访问)
  static const String GUESS_LIKE =
      "/home/goods/guessLike"; //猜你喜欢接口地址,返回的类型是GoodsItems类型
  static const String LOGIN = "/login"; //登录请求接口(Post请求)
  static const String USER_PROFILE = "/member/profile"; //用户信息接口地址
}
