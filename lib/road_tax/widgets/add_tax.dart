import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/road_tax/cubit/road_tax_cubit.dart';
import 'package:road_guard/settings/cubit/cubit.dart';
import 'package:road_guard/utils/size_config.dart';
import 'package:road_guard/widgets/widgets.dart'; // For image picking
import 'package:uuid/uuid.dart';

class AddTaxBody extends StatefulWidget {
  const AddTaxBody({super.key});

  @override
  State<AddTaxBody> createState() => _AddTaxBodyState();
}

class _AddTaxBodyState extends State<AddTaxBody> {
  final _formKey = GlobalKey<FormState>();
  final _licenseNumberController = TextEditingController();
  final _nameController = TextEditingController();
  DateTime? _expiryDate;
  DateTime? _issuedDate;
  XFile? _licenseImage;

  // Pick image for road tax
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _licenseImage = pickedFile;
      }
    });
  }

  // Select expiry date
  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 6),
      lastDate: DateTime(now.year + 6),
    );

    if (pickedDate != null && pickedDate != _expiryDate) {
      setState(() {
        _expiryDate = pickedDate;
      });
    }
  }

  // Select issued date
  Future<void> _selectIssuedDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 6),
      lastDate: DateTime(now.year + 6),
    );

    if (pickedDate != null && pickedDate != _issuedDate) {
      setState(() {
        _issuedDate = pickedDate;
      });
    }
  }

  // Submit form data
  void _submitForm() {
    final user = context.read<AuthBloc>().state.user;

    if (_formKey.currentState?.validate() ?? false) {
      final image = _licenseImage;
      final uuid = const Uuid().v4();
      final now = DateTime.now();

      // final data = {
      // 'createdAt': FieldValue.serverTimestamp(),
      // 'uuid': uuid,
      // 'email': user.email,
      // 'makeAndModel': _nameController.text,
      // 'numberPlate': _licenseNumberController.text,
      // 'expiryDate': _expiryDate?.toIso8601String(),
      // 'issuedDate': _issuedDate?.toIso8601String(),
      // 'status': _expiryDate!.isAfter(now) ? 'Active' : 'Expired',
      // };

      final data = {
        'createdAt': FieldValue.serverTimestamp(),
        'uuid': uuid,
        'email': user.email,
        'makeAndModel': _nameController.text,
        'numberPlate': _licenseNumberController.text,
        // Send as Timestamp, NOT string
        'expiryDate':
            _expiryDate != null ? Timestamp.fromDate(_expiryDate!) : null,
        'issuedDate':
            _issuedDate != null ? Timestamp.fromDate(_issuedDate!) : null,
        'status': _expiryDate != null && _expiryDate!.isAfter(now)
            ? 'Active'
            : 'Expired',
      };

      context
          .read<RoadTaxCubit>()
          .addDriversLicenseAndImage(image, context, data, uuid, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadTaxCubit, RoadTaxState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(16)),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Make and Model',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your vehicle make and model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // License Number Field
                  TextFormField(
                    controller: _licenseNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Registration Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your vehicle registration number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Expiry Date Picker
                  GestureDetector(
                    onTap: _selectExpiryDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: _expiryDate == null
                              ? 'Expiry Date'
                              : '${_expiryDate?.toLocal()}'.split(' ')[0],
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_expiryDate == null) {
                            return 'Please select an expiry date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),

                  // Issued Date Picker
                  GestureDetector(
                    onTap: _selectIssuedDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: _issuedDate == null
                              ? 'Issued Date'
                              : '${_issuedDate?.toLocal()}'.split(' ')[0],
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_issuedDate == null) {
                            return 'Please select an issued date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),

                  // License Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _licenseImage == null
                          ? const Center(child: Text('Tap to add image'))
                          : Image.file(
                              File(_licenseImage!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),

                  // Submit Button
                  AppButton(
                    loading: state.isLoading,
                    text: 'Submit',
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
