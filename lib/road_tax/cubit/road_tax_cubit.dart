import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:net_source/net_source.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/models/road_tax.dart';
import 'package:road_guard/utils/constants.dart';
import 'package:road_guard/utils/enums.dart';
part 'road_tax_state.dart';

class RoadTaxCubit extends Cubit<RoadTaxState> {
  RoadTaxCubit(this.firebaseRepo) : super(const RoadTaxState());
  final FirebaseRepo firebaseRepo;

  Future<void> updateAction(String action) async {
    if (isClosed) return;
    var title = '';
    if (action == 'Add') title = 'Add RoadTax';
    if (action == 'View') title = 'RoadTax';
    if (action == 'Update') title = 'Update  RoadTax';
    emit(state.copyWith(action: action, title: title));
  }


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
          roadTax,
          uuid,
        );
        if (isClosed) return;
        emit(
          state.copyWith(
            message: 'RoadTax uploaded successfully',
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
      collectionPath: roadTax,
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
    RoadTax driverLicense1,
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
        collectionPath: roadTax,
        id: driverLicense1.uuid,
        data: data,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          message: 'RoadTax uploaded successfully',
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
