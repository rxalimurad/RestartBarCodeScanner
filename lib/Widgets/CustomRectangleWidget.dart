import 'package:flutter/material.dart';

class CustomRectangleWidget extends StatelessWidget {
  final Color rectangleColor;
  final String labelText;
  final double width;
  final double height;
  final bool isSelected;

  const CustomRectangleWidget({
    Key? key,
    required this.rectangleColor,
    required this.labelText,
    required this.width,
    required this.height,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: rectangleColor,
          border: Border.all(
            color: isSelected ? Colors.black : rectangleColor,
            width: isSelected ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            labelText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ),
      ),
    );
  }
}
