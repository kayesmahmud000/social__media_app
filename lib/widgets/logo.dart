import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/ui_helper.dart';

class Logo {
  static Widget logo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 150, child: UiHelper.customImage(imageUrl: 'wave.png')),
        Positioned(
          bottom: -45,
          child: SizedBox(
            width: 130,
            child: UiHelper.customImage(imageUrl: 'logo2.png'),
          ),
        ),
      ],
    );
  }
}
