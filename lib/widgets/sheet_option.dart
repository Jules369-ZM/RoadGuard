import 'package:flutter/material.dart';
import 'package:road_guard/utils/strings.dart';
import 'package:road_guard/utils/utils.dart';
class SheetOption extends StatelessWidget {
  const SheetOption({
    required this.title,
    required this.icon,
    required this.imageUrl,
    required this.onTap,
    this.dismiss = true,
    this.subtitle,
    this.color,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? imageUrl;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? color;
  final bool dismiss;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(4),
        vertical: getProportionateScreenHeight(4),
      ),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(getProportionateScreenHeight(8)),
        child: imageUrl != null
            ? Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(4)),
                child: Image.network(
                  '${config.image}$imageUrl',
                  fit: BoxFit.scaleDown,
                  height: 32,
                  width: 32,
                ),
              )
            : Icon(
                icon,
                color: color ?? Theme.of(context).colorScheme.tertiary,
              ),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: () {
        if (dismiss) Navigator.pop(context);
        onTap.call();
      },
    );
  }
}
