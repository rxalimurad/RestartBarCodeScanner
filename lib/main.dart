import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:restart_scanner/Constants/Extensions.dart';
import 'package:restart_scanner/DisconnectedScreen/DisconnectedScreen.dart';
import 'package:restart_scanner/ProductsList/ProductsListScreen.dart';

import 'Constants/Constants.dart';
import 'Routes/routes.dart';

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
              connected: ProductsListScreen(),
              disconnected: DisconnectedScreen(),
            )));
  }
}
