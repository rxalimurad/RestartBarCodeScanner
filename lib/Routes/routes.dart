import 'package:get/get.dart';
import 'package:restart_scanner/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:restart_scanner/ProductsList/ProductsListScreen.dart';
import 'package:restart_scanner/ProfileScreen/ProfileScreen.dart';
import 'package:restart_scanner/SignupScreen/SignupScreen.dart';

import '../ForgotPassword/ChangePasswordScreen.dart';
import '../LoginScreen/LoginScreen.dart';

appRoutes() => [
      GetPage(
        name: '/ProductsListScreen',
        page: () => ProductsListScreen(),
        middlewares: [MyMiddelware()],
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 300),
      ),
      GetPage(
        name: '/SignupScreen',
        page: () => SignupScreen(),
        middlewares: [MyMiddelware()],
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 300),
      ),
      GetPage(
        name: '/LoginScreen',
        page: () => LoginScreen(),
        middlewares: [MyMiddelware()],
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 300),
      ),
      GetPage(
        name: '/forgotPassword',
        page: () => ForgotPasswordScreen(),
        middlewares: [MyMiddelware()],
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 300),
      ),
      GetPage(
        name: '/changePassword',
        page: () => ChangePasswordScreen(),
        middlewares: [MyMiddelware()],
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 300),
      ),
      GetPage(
        name: '/profileScreen',
        page: () => ProfileScreen(),
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
