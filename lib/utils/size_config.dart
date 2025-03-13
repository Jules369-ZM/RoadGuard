import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenRadius;
  static late double screenHeight;
  static late double statusBarHeight;
  static late Orientation orientation;
    static late double textMultiplier;
      static late double blockSizeVertical;

  /// Initializes the size configuration using [BuildContext].
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenRadius = _mediaQueryData.size.width / 2;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
      blockSizeVertical = screenHeight / 100;
    statusBarHeight = _mediaQueryData.padding.top;
      textMultiplier = blockSizeVertical;
  }
}

/// Get the proportionate height as per the screen size.
/// The [inputHeight] is a design reference, which will be scaled
/// to match the current screen's height proportionally.
double getProportionateScreenHeight(double inputHeight) {
  final screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that the designer used as a reference
  return (inputHeight / 812.0) * screenHeight;
}

/// Get the proportionate width as per the screen size.
/// The [inputWidth] is a design reference, which will be scaled
/// to match the current screen's width proportionally.
double getProportionateScreenWidth(double inputWidth) {
  final screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that the designer used as a reference
  return (inputWidth / 375.0) * screenWidth;
}
