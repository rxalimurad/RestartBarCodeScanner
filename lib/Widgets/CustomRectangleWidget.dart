import 'package:flutter/material.dart';

class CustomRectangleWidget extends StatelessWidget {
  final Color rectangleColor;
  final String labelText;
  final double width;
  final double height;

  const CustomRectangleWidget({
    Key? key,
    required this.rectangleColor,
    required this.labelText,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: rectangleColor,
          border: Border.all(color: rectangleColor, width: 4),
          borderRadius:
              BorderRadius.circular(8.0), // Adjust border radius as needed
        ),
        child: Center(
          child: Text(
            labelText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0, // Adjust font size as needed
            ),
          ),
        ),
      ),
    );
  }
}
