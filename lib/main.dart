import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:restart_scanner/Constants/Extensions.dart';
import 'package:restart_scanner/DisconnectedScreen/DisconnectedScreen.dart';
import 'package:restart_scanner/LocalDataHandler/LocalDataHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppIntro/AppIntro.dart';
import 'Constants/Constants.dart';
import 'LoginScreen/LoginScreen.dart';
import 'ProductsList/ProductsListScreen.dart';
import 'Routes/routes.dart';

enum LandingScreen {
  appIntro,
  login,
  productsList,
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  // FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(
        connectionNotificationOptions: ConnectionNotificationOptions(
            alignment: AlignmentDirectional.bottomCenter),
        child: GetMaterialApp(
            title: 'Restart Educational Foundation',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Montserrat',
              colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
              primarySwatch: primaryColor.toMaterialColor(),
              hintColor: primaryColor,
              primaryColor: primaryColor,
              useMaterial3: false,
            ),
            getPages: appRoutes(),
            home: ConnectionNotifierToggler(
              connected: FutureBuilder(
                future: getLandingScreen(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return snapshot?.data ?? Container();
                  }
                },
              ),
              disconnected: DisconnectedScreen(),
            )));
  }

  Future<Widget> getLandingScreen() async {
    var isAppIntroShownAlready = await checkAppIntro();
    var isUserLoggedIn = await LocalDataHandler.getUserData();
    if (isAppIntroShownAlready == true) {
      if (isUserLoggedIn != null) {
        return ProductsListScreen();
      } else {
        return LoginScreen();
      }
    } else {
      return AppIntro();
    }
  }

  Future<bool?> checkAppIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('appIntro');
  }
}
