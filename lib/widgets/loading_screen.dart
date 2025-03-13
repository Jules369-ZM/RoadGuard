// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:road_guard/utils/strings.dart';
import 'package:road_guard/utils/utils.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.message = Strings.loading,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(),
          SizedBox(height: getProportionateScreenHeight(16)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
