import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barcode/barcode.dart';

class BarcodeGeneratorWidget extends StatelessWidget {
  final String data;

  const BarcodeGeneratorWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          color: Colors.white,
          child: getBarCode().isNotEmpty ? SvgPicture.string(getBarCode()) : Text("Invalid barcode"),
        ),
      ),
    );
    }

    String getBarCode(){
    try {
      Barcode? barcode = Barcode.upcA();
      String svgCode = barcode.toSvg(data);
      print(svgCode);
      return svgCode;
    } catch(ee) {
      return "";
    }
    }
}
