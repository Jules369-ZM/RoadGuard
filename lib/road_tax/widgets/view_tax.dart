import 'package:flutter/material.dart';
import 'package:road_guard/models/road_tax.dart';
import 'package:road_guard/utils/utils.dart';
import 'package:road_guard/widgets/widgets.dart';

class ViewTaxBody extends StatelessWidget {
  const ViewTaxBody({
    required this.license,
    required this.onTap,
    super.key,
  });
  final RoadTax license;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    final isExpired = license.expiryDate.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        // Prevents infinite height issue
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Prevents Column from expanding infinitely
          children: [
            // License Image
            if (license.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  license.image!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),

            const SizedBox(height: 20),

            // Name
            Text(
              license.makeAndModel,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            // const SizedBox(height: 10),
            const Divider(),
            // License Number
            buildDetailRow('Number Plate', license.numberPlate),

            // Issued Date
            buildDetailRow(
              'Issued Date',
              '${license.issuedDate.toLocal()}'.split(' ')[0],
            ),

            // Expiry Date
            buildDetailRow(
              'Expiry Date',
              '${license.expiryDate.toLocal()}'.split(' ')[0],
            ),

            // Status
            buildDetailRow(
              'Status',
              license.currentStatus,
              color: isExpired ? Colors.red : Colors.green,
              isBold: true,
            ),
            SizedBox(height: getProportionateScreenHeight(48)),
            AppButton(text: 'Edit', onPressed: onTap, icon: null),
          ],
        ),
      ),
    );
  }
}

Widget buildDetailRow(
  String label,
  String value, {
  Color? color,
  bool isBold = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black,
          ),
        ),
      ],
    ),
  );
}
