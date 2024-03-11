import 'package:flutter/material.dart';

class DisconnectedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Text("No Internet Connection.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Image.asset("assets/reconnect.png",
                height: 200, color: Colors.redAccent),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
