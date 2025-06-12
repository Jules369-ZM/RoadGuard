import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:road_guard/main/main.dart';
import 'package:road_guard/models/road_tax.dart';
import 'package:road_guard/road_tax/cubit/road_tax_cubit.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/utils/size_config.dart';
import 'package:road_guard/widgets/widgets.dart';

class UpdateTaxBody extends StatefulWidget {
  const UpdateTaxBody({super.key});

  @override
  State<UpdateTaxBody> createState() => _UpdateTaxBodyState();
}

class _UpdateTaxBodyState extends State<UpdateTaxBody> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController licenseNumberController;
  late TextEditingController issuedDateController;
  late TextEditingController expiryDateController;
  String? _selectedStatus;
  File? _selectedImage;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    // Do not use context-dependent code here.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now it's safe to access context-dependent values here.

    final license = ModalRoute.of(context)!.settings.arguments! as RoadTax;
    if (!isFirst) return;
    isFirst = false;
    nameController = TextEditingController(text: license.makeAndModel);
    licenseNumberController = TextEditingController(text: license.numberPlate);
    issuedDateController = TextEditingController(
      text: license.issuedDate.toIso8601String().split('T').first,
    );
    expiryDateController = TextEditingController(
      text: license.expiryDate.toIso8601String().split('T').first,
    );
    _selectedStatus = license.status;

    if (license.image != null) {
      // _selectedImage = File(license.image!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    licenseNumberController.dispose();
    issuedDateController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  void _updateLicense() {
    final license = ModalRoute.of(context)!.settings.arguments! as RoadTax;
    if (_formKey.currentState!.validate()) {
      // final updatedLicense = RoadTax(
      // uuid: license.uuid,
      // email: license.email,
      // makeAndModel: nameController.text,
      // numberPlate: licenseNumberController.text,
      // issuedDate: DateTime.parse(issuedDateController.text),
      // expiryDate: DateTime.parse(expiryDateController.text),
      // status: _selectedStatus!,
      // image: _selectedImage?.path ?? license.image,
      // );
      final now = DateTime.now();
      final expiryDate = DateTime.tryParse(expiryDateController.text);
      final issuedDate = DateTime.tryParse(issuedDateController.text);
      final data = {
        'updatedAt': FieldValue.serverTimestamp(),
        'uuid': license.uuid,
        'email': license.email,
        'makeAndModel': license.makeAndModel,
        'numberPlate': license.numberPlate,
        // Send as Timestamp, NOT string
        'expiryDate':
            expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
        'issuedDate':
            issuedDate != null ? Timestamp.fromDate(issuedDate) : null,
        'status': expiryDate != null && expiryDate.isAfter(now)
            ? 'Active'
            : 'Expired',
      };

      context.read<RoadTaxCubit>().updateLicense(
            data,
            _selectedImage,
            license,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final license = ModalRoute.of(context)!.settings.arguments! as RoadTax;
    return BlocConsumer<RoadTaxCubit, RoadTaxState>(
      listener: (context, state) {
        if (state.status == CurrentStatus.error) {
          showErrorSnackBar(context, message: state.message);
        }
        if (state.status == CurrentStatus.success) {
          showSuccessSnackBar(context, message: state.message);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MainPage.route(),
                (Route<dynamic> route) => false,
              );
            }
          });
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedImage != null)
                    Center(
                      child: Image.file(
                        _selectedImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (license.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        license.image!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Make and Model',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter make and Model' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: licenseNumberController,
                    decoration:
                        const InputDecoration(labelText: 'License Number'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter license number' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: issuedDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Issued Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(issuedDateController),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter issued date' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: expiryDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(expiryDateController),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter expiry date' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: ['Active', 'Expired', 'Suspended']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a status' : null,
                  ),
                  SizedBox(height: getProportionateScreenHeight(48)),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _updateLicense,
                      loading: state.isLoading,
                      text: 'UPDATE',
                    ),
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
