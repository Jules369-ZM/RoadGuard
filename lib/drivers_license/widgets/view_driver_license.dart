import 'package:flutter/material.dart';
import 'package:road_guard/models/models.dart';

class ViewDriversLicenseBody extends StatelessWidget {
  const ViewDriversLicenseBody({required this.license, super.key});
  final DriverLicense license;

  @override
  Widget build(BuildContext context) {
    final isExpired = license.expiryDate.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Driver License Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
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
                    child:
                        const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),

                const SizedBox(height: 20),

                // Name
                Text(
                  license.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // License Number
                _buildDetailRow('License Number', license.licenseNumber),

                // Issued Date
                _buildDetailRow(
                  'Issued Date',
                  '${license.issuedDate.toLocal()}'.split(' ')[0],
                ),

                // Expiry Date
                _buildDetailRow(
                  'Expiry Date',
                  '${license.expiryDate.toLocal()}'.split(' ')[0],
                ),

                // Status
                _buildDetailRow(
                  'Status',
                  license.currentStatus,
                  color: isExpired ? Colors.red : Colors.green,
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
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
}
