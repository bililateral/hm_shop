import 'package:get/get.dart';
import 'package:hm_shop/viewmodels/user.dart';

//需要共享的对象 要有一些共享的属性  属性需要响应式更新
class UserController extends GetxController {
  var user = UserInfo.fromJSON({}).obs; //.obs结尾意味着user变量被监听了
  //此时如果想要获取user的值需要通过user.value获取
  updateUserInfo(UserInfo newUser) {
    user.value = newUser;
  }
}
