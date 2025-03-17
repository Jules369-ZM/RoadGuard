import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:net_source/net_source.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/models/models.dart';
import 'package:road_guard/utils/constants.dart';
import 'package:road_guard/utils/enums.dart';
part 'drivers_license_state.dart';

class DriversLicenseCubit extends Cubit<DriversLicenseState> {
  DriversLicenseCubit(this.firebaseRepo) : super(const DriversLicenseState());
  final FirebaseRepo firebaseRepo;

  Future<void> updateAction(String action) async {
    if (isClosed) return;
    var title = '';
    if (action == 'Add') title = "Add Driver's License";
    if (action == 'View') title = "Driver's Licenses";
    if (action == 'Update') title = "Update Driver's License";
    emit(state.copyWith(action: action, title: title));
  }

  // void addDriversLicense(Map<String, Object?> data) {}

  Future<void> addDriversLicenseAndImage(
    XFile? image,
    BuildContext context,
    Map<String, Object?> data,
    String uuid,
    User user,
  ) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: CurrentStatus.loading));
      if (image == null) {
        emit(
          state.copyWith(
            message: 'No image selected',
            status: CurrentStatus.error,
          ),
        );
        return;
      }
      if (isClosed) return;
      emit(
        state.copyWith(
          message: 'Uploading...',
          status: CurrentStatus.loading,
        ),
      );
      final imageFile = File(image.path);
      final imageUrl = await firebaseRepo.uploadImage(imageFile, {
        'uuid': uuid,
        'id': uuid.hashCode,
        'email': user.email,
      });
      if (imageUrl != null) {
        data['image'] = imageUrl;
        await firebaseRepo.addDocument(
          data,
          driverLicense,
          uuid,
        );
        if (isClosed) return;
        emit(
          state.copyWith(
            message: 'License uploaded successfully',
            status: CurrentStatus.success,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
  }

  Future<void> getDriversLicenses(String email) async {
    if (isClosed) return;
    emit(state.copyWith(status: CurrentStatus.loading));
    final res = await firebaseRepo.readDocumentsWhere(
      collectionPath: driverLicense,
      field: 'email',
      value: email,
    );
    log('res: $res');
    if (isClosed) return;
    emit(
      state.copyWith(
        status: CurrentStatus.initial,
        data: {
          'driversLicenses': res,
        },
      ),
    );
  }

  Future<void> updateLicense(
    Map<String, dynamic> data,
    File? image,
    DriverLicense driverLicense1,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: CurrentStatus.loading));
    if (image == null) {
      emit(
        state.copyWith(
          message: 'No image selected',
          status: CurrentStatus.error,
        ),
      );
      return;
    }
    if (isClosed) return;
    emit(
      state.copyWith(
        message: 'Uploading...',
        status: CurrentStatus.loading,
      ),
    );
    final imageFile = image;
    final imageUrl = await firebaseRepo.updateImage(
      imageFile,
      {
        'uuid': driverLicense1.uuid,
        'id': driverLicense1.uuid.hashCode,
        'email': driverLicense1.email,
      },
      images,
    );
    if (imageUrl != null) {
      data['image'] = imageUrl;
      await firebaseRepo.updateDocument(
        collectionPath: driverLicense,
        id: driverLicense1.uuid,
        data: data,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          message: 'License uploaded successfully',
          status: CurrentStatus.success,
        ),
      );
    } else {
      if (isClosed) return;
      emit(
        state.copyWith(
          message: 'Image upload failed',
          status: CurrentStatus.error,
        ),
      );
    }
  }
}
