import 'package:get/get.dart';
import 'package:restart_scanner/Home/HomeScreen.dart';
import 'package:restart_scanner/ProductsList/ProductsListScreen.dart';

appRoutes() => [
  GetPage(
    name: '/home',
    page: () => MyHomePage(),
    transition: Transition.leftToRightWithFade,
    transitionDuration: Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/all',
    page: () => ProductsListScreen(),
    middlewares: [MyMiddelware()],
    transition: Transition.rightToLeft,
    transitionDuration: Duration(milliseconds: 300),
  ),

];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    print(page?.name);
    return super.onPageCalled(page);
  }
}