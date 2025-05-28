import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:road_guard/app/theme/theme.dart';
import 'package:road_guard/auth/auth_bloc.dart';
import 'package:road_guard/main/view/main_page.dart';
import 'package:road_guard/profile/cubit/cubit.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/widgets/app_button.dart';
import 'package:road_guard/widgets/app_snack_bar.dart';
import 'package:road_guard/widgets/phone_field.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String fullPhone = '';

  String countryCode = '260';
  String localPhone = '';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    // final localPhone = user.phone!.replaceFirst(RegExp(r'^\+\d{1,4}'), '');
    // Use a regex to extract the country code and local part
    // final match = RegExp(r'^\+(\d{1,4})(\d+)$').firstMatch(fullPhone);
    // if (match != null) {
    // countryCode = '+${match.group(1)}'; // e.g., "+95"
    // localPhone = match.group(2)!; // e.g., "9123456789"
    // }
    countryCode = user.countryCode!;
    localPhone = user.phone!;
    fullPhone = user.fullPhone!;

    log('Country Code: $countryCode');
    log('Local Phone: $localPhone');
    log('Full Phone: $fullPhone');

    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    final user = context.read<AuthBloc>().state.user;
    // final uid = user.id;
    fullPhone = countryCode + _phoneController.text.trim();

    final data = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'countryCode': countryCode.trim(),
      'fullPhone': fullPhone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    log('User data: $data');
    log('Country Code: $countryCode');
    log('Local Phone: ${_phoneController.text}');
    log('Full Phone: $fullPhone');
    if (_formKey.currentState!.validate()) {
      await context.read<ProfileCubit>().updateUser(data, user);
    } else {
      showErrorSnackBar(context, message: 'Please fill all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
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
        if (state.status == CurrentStatus.error) {
          showErrorSnackBar(context, message: state.message);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                if (user.avatar != null) ...[
                  SizedBox(
                    width: 120, // 2 * radius
                    height: 120,
                    child: ClipOval(
                      child: user.avatar != null && user.avatar!.isNotEmpty
                          ? Image.network(
                              user.avatar!,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              'assets/person.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: user.email,
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Email',
                  ),
                  // const InputDecoration(labelText: 'Email'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                PhoneField(
                  _phoneController,
                  validator: (number, code1) {
                    if (number == null || code1.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    countryCode = code1;
                    localPhone = number;
                    setState(() {});
                    return null;
                  },
                ),
                // TextFormField(
                // controller: _phoneController,
                // decoration: const InputDecoration(labelText: 'Phone Number'),
                // keyboardType: TextInputType.phone,
                // validator: (value) {
                // if (value == null || value.isEmpty) {
                // return 'Please enter your phone number';
                // }
                // return null;
                // },
                // ),
                const SizedBox(height: 24),
                AppButton(
                  loading: state.status == CurrentStatus.loading,
                  onPressed: _updateUser,
                  text: 'Save Changes',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
