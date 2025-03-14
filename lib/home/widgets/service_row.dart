import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:road_guard/utils/utils.dart';

class ServiceButtonsRow extends StatelessWidget {
  const ServiceButtonsRow({required this.children, super.key});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class ServiceTileButton extends StatelessWidget {
  const ServiceTileButton({
    required this.text,
    required this.imageUrl,
    super.key,
    this.onTap,
    this.icon,
  });
  final String text;
  final String imageUrl;
  final dynamic Function()? onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: imageUrl.isEmpty
                ? _DefaultIcon(icon)
                : Center(
                    child: SvgPicture.asset(
                      imageUrl,
                      fit: BoxFit.scaleDown,
                      semanticsLabel: 'Services icons',
                      // height: 32,
                      // width: 32,
                    ),
                  ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultIcon extends StatelessWidget {
  const _DefaultIcon(this.icon);
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.phone,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 32,
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Transform.rotate(
            angle: -0.5,
            child: Icon(
              icon ?? Icons.traffic,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
