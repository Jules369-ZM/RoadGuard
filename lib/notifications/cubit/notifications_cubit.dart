import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:road_guard/models/notification.dart';
import 'package:road_guard/utils/constants.dart';
import 'package:road_guard/utils/enums.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.firebaseRepo) : super(const NotificationsState());
  final FirebaseRepo firebaseRepo;
  FutureOr<void> fetchNotifications(String email) async {
    try {
      if (isClosed) return null;

      // Simulating a delay as if fetching notifications
      // from a remote server or local database.
      emit(state.copyWith(status: CurrentStatus.loading));

      // await Future.delayed(
      // const Duration(seconds: 1),
      // () {},
      // ); // Simulated delay
      final res = await firebaseRepo.readDocumentsWhere(
        collectionPath: notifications,
        field: 'email',
        value: email,
      );
      log('res: $res');
      if (isClosed) return;
      final notif = res.map(Notification.fromMap).toList();
      // After fetching notifications, emit the state with the loaded data.
      if (isClosed) return null;
      emit(
        state.copyWith(
          notifications: notif,
          status: CurrentStatus.success,
        ),
      );
    } catch (e) {
      if (isClosed) return null;

      // If an error occurs, emit an error state with a message.
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
  }
}
