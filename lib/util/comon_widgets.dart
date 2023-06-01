import 'package:flutter/material.dart';
import 'package:influencer/util/image_const.dart';

class AssetImageWidget extends StatelessWidget {
  const AssetImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(ImageConstant.dummyImage1.toString());
  }
}
