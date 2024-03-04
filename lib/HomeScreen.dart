import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Constants.dart';
import 'ScanScreen.dart';
import 'UploadCSVScreen.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            ScanScreen(),
            UploadCSVScreen(),
          ],
        ),
        bottomNavigationBar:  Container(
            color: Colors.white,
            child: SafeArea(
              child: TabBar(
                indicatorColor: primaryColor,
              labelColor: primaryColor,

              tabs: [
                Tab(icon: Icon(Icons.document_scanner_outlined), text: "Scan"),
                Tab(icon: Icon(Icons.upload_sharp), text: "Upload new CSV"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
