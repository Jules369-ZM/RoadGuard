import 'package:flutter/material.dart';
import 'package:road_guard/utils/utils.dart';
import 'package:road_guard/widgets/app_alerts.dart';

class TextFieldHeader extends StatelessWidget {
  const TextFieldHeader({
    required this.text,
    this.infoText,
    super.key,
  });
  final String text;
  final String? infoText;

  Future<void> _showInfoDialog(BuildContext context) async {
    if (infoText == null) return;

    return showAppDialog(
      context,
      title: 'Information',
      message: infoText!,
      dialogType: DialogType.info,
      yesText: 'Close',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          if (infoText != null)
            IconButton(
              icon: Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => _showInfoDialog(context),
            ),
        ],
      ),
    );
  }
}
