import 'package:get/get.dart';
import 'package:shopping_app/app/modules/controllers/shopping_controller.dart';

import '../../utills/Gems_rates.dart';

class GemsViewController extends GetxController {
  //TODO: Implement GemsViewController
  // [j.]NavCTL navCTL = Get.find();
  ShoppingController shoppingCTL = Get.find();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  increase_inter_gems() {
    shoppingCTL.increaseGEMS(GEMS_RATE.INTER_INCREAES_GEMS_RATE);
  }

  increase_reward_gems() {
    shoppingCTL.increaseGEMS(GEMS_RATE.REWARD_INCREAES_GEMS_RATE);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
