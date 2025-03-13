import 'package:flutter/material.dart';
import 'package:road_guard/utils/utils.dart';

class ServiceData {
  ServiceData({
    required this.title,
    required this.icon,
    this.iconColor,
    this.onTap,
    this.available = true,
  });

  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool available;
}

class ServiceIcon extends StatelessWidget {
  const ServiceIcon({
    required this.title,
    required this.icon,
    super.key,
    this.iconColor,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(getProportionateScreenHeight(16)),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
