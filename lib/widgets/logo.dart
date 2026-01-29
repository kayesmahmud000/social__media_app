import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/ui_helper.dart';

class Logo {
  static Widget logo({
    double top = 0,
    double bottom = -45,
    double width = 130,
    double w = 150,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: w,
          child: UiHelper.customImage(imageUrl: 'wave.png'),
        ),
        Positioned(
          bottom: bottom,
          child: SizedBox(
            width: width,
            child: UiHelper.customImage(imageUrl: 'logo2.png'),
          ),
        ),
      ],
    );
  }
}
