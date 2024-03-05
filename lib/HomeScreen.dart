import 'package:flutter/material.dart';

import 'ScanScreen.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: ScanScreen()),
      ),
    );
  }
}
