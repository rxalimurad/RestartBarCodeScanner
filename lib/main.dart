
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:restart_scanner/Constants/Extensions.dart';

import 'Constants/Constants.dart';
import 'Home/HomeScreen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        primarySwatch: primaryColor.toMaterialColor(),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}
