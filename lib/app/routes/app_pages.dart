import 'package:get/get.dart';
import 'package:shopping_app/app/modules/bindings/shopping_binding.dart';
import 'package:shopping_app/app/modules/views/shopping_view.dart';

import '../modules/bindings/gems_view_binding.dart';
import '../modules/bindings/splash_binding.dart';
import '../modules/views/gems_view_view.dart';
import '../modules/views/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SplashScreen;

  static final routes = [
    GetPage(
      name: _Paths.SplashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ShoppingView,
      page: () => ShoppingView(),
      binding: ShoppingBinding(),
    ),
    GetPage(
      name: _Paths.GemsView,
      page: () => GemsView(),
      binding: GemsViewBinding(),
    ),
  ];
}
