import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 20,
          child: LoadingAnimationWidget.fallingDot(
            color:const Color.fromARGB(255, 218, 119, 223),
            size: 70,
          )),
    );
  }
}
