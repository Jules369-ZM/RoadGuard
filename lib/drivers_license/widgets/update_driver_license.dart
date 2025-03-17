import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:road_guard/drivers_license/cubit/cubit.dart';
import 'package:road_guard/main/main.dart';
import 'package:road_guard/models/models.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/utils/size_config.dart';
import 'package:road_guard/widgets/widgets.dart';

class UpdateDriversLicenseBody extends StatefulWidget {
  const UpdateDriversLicenseBody({super.key});

  @override
  State<UpdateDriversLicenseBody> createState() =>
      _UpdateDriversLicenseBodyState();
}

class _UpdateDriversLicenseBodyState extends State<UpdateDriversLicenseBody> {
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

    final license =
        ModalRoute.of(context)!.settings.arguments! as DriverLicense;
    if (!isFirst) return;
    isFirst = false;
    nameController = TextEditingController(text: license.name);
    licenseNumberController =
        TextEditingController(text: license.licenseNumber);
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
    final license =
        ModalRoute.of(context)!.settings.arguments! as DriverLicense;
    if (_formKey.currentState!.validate()) {
      final updatedLicense = DriverLicense(
        uuid: license.uuid,
        email: license.email,
        name: nameController.text,
        licenseNumber: licenseNumberController.text,
        issuedDate: DateTime.parse(issuedDateController.text),
        expiryDate: DateTime.parse(expiryDateController.text),
        status: _selectedStatus!,
        image: _selectedImage?.path ?? license.image,
      );

      context.read<DriversLicenseCubit>().updateLicense(
            updatedLicense.toMap(),
            _selectedImage,
            updatedLicense,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final license =
        ModalRoute.of(context)!.settings.arguments! as DriverLicense;
    return BlocConsumer<DriversLicenseCubit, DriversLicenseState>(
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
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value!.isEmpty ? 'Enter name' : null,
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
