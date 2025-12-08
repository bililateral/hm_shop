//Map<String,dynamic>
//每一个轮播图具体类型
class BannerItem {
  String id;
  String imgUrl;
  BannerItem({required this.id, required this.imgUrl});

  //扩展一个工厂函数  一般用factory声明  一般用来创建实例对象(这里是把json文件转成BannerItem对象)
  factory BannerItem.fromJSON(Map<String, dynamic> json) {
    //必须返回一个BannerItem对象
    return BannerItem(id: json["id"] ?? "", imgUrl: json["imgUrl"] ?? "");
  }
}

//定义分类的具体内容
class CategoryItem {
  String id;
  String name;
  String picture;
  List<CategoryItem>? children;
  dynamic goods; // 根据JSON结构，goods可能为null或包含其他数据

  CategoryItem({
    required this.id,
    required this.name,
    required this.picture,
    this.children,
    this.goods,
  });

  factory CategoryItem.fromJSON(Map<String, dynamic> json) {
    List<CategoryItem>? childrenList;

    // 处理children字段
    if (json["children"] != null && json["children"] is List) {
      childrenList = [];
      for (var child in json["children"]) {
        childrenList.add(CategoryItem.fromJSON(child));
      }
    }

    return CategoryItem(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      picture: json["picture"]?.toString() ?? "",
      children: childrenList,
      goods: json["goods"],
    );
  }
}

//定义特惠推荐
class SpecialRecommendResult {
  String id;
  String title;
  List<SubType> subTypes;

  SpecialRecommendResult({
    required this.id,
    required this.title,
    required this.subTypes,
  });

  factory SpecialRecommendResult.fromJSON(Map<String, dynamic> json) {
    List<SubType> subTypeList = [];
    if (json["subTypes"] != null && json["subTypes"] is List) {
      for (var item in json["subTypes"]) {
        subTypeList.add(SubType.fromJSON(item));
      }
    }

    return SpecialRecommendResult(
      id: json["id"]?.toString() ?? "",
      title: json["title"]?.toString() ?? "",
      subTypes: subTypeList,
    );
  }
}

class SubType {
  String id;
  String title;
  GoodsItems goodsItems;

  SubType({required this.id, required this.title, required this.goodsItems});

  factory SubType.fromJSON(Map<String, dynamic> json) {
    return SubType(
      id: json["id"]?.toString() ?? "",
      title: json["title"]?.toString() ?? "",
      goodsItems: GoodsItems.fromJSON(json["goodsItems"] ?? {}),
    );
  }
}

class GoodsItems {
  int counts;
  int pageSize;
  int pages;
  int page;
  List<GoodsItem> items;

  GoodsItems({
    required this.counts,
    required this.pageSize,
    required this.pages,
    required this.page,
    required this.items,
  });

  factory GoodsItems.fromJSON(Map<String, dynamic> json) {
    List<GoodsItem> itemList = [];
    if (json["items"] != null && json["items"] is List) {
      for (var item in json["items"]) {
        itemList.add(GoodsItem.fromJSON(item));
      }
    }

    return GoodsItems(
      counts: json["counts"] ?? 0,
      pageSize: json["pageSize"] ?? 0,
      pages: json["pages"] ?? 0,
      page: json["page"] ?? 0,
      items: itemList,
    );
  }
}

class GoodsItem {
  String id;
  String name;
  String? desc;
  String price;
  String picture;
  int orderNum;

  GoodsItem({
    required this.id,
    required this.name,
    this.desc,
    required this.price,
    required this.picture,
    required this.orderNum,
  });

  factory GoodsItem.fromJSON(Map<String, dynamic> json) {
    return GoodsItem(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      desc: json["desc"]?.toString(),
      price: json["price"]?.toString() ?? "",
      picture: json["picture"]?.toString() ?? "",
      orderNum: json["orderNum"] ?? 0,
    );
  }
}

class GoodsDetailItem extends GoodsItem {
  int payCount = 0;

  /// 商品详情项
  GoodsDetailItem({
    required super.id,
    required super.name,
    required super.price,
    required super.picture,
    required super.orderNum,
    required this.payCount,
  }) : super(desc: "");
  // 转化方法
  factory GoodsDetailItem.formJSON(Map<String, dynamic> json) {
    return GoodsDetailItem(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      price: json["price"]?.toString() ?? "",
      picture: json["picture"]?.toString() ?? "",
      orderNum: int.tryParse(json["orderNum"]?.toString() ?? "0") ?? 0,
      payCount: int.tryParse(json["payCount"]?.toString() ?? "0") ?? 0,
    );
  }
}

class GoodsDetailItems {
  int counts;
  int pageSize;
  int pages;
  int page;
  List<GoodsDetailItem> items;

  GoodsDetailItems({
    required this.counts,
    required this.pageSize,
    required this.pages,
    required this.page,
    required this.items,
  });

  factory GoodsDetailItems.fromJSON(Map<String, dynamic> json) {
    List<GoodsDetailItem> itemList = [];
    if (json["items"] != null && json["items"] is List) {
      for (var item in json["items"]) {
        itemList.add(GoodsDetailItem.formJSON(item));
      }
    }

    return GoodsDetailItems(
      counts: json["counts"] ?? 0,
      pageSize: json["pageSize"] ?? 0,
      pages: json["pages"] ?? 0,
      page: json["page"] ?? 0,
      items: itemList,
    );
  }
}
