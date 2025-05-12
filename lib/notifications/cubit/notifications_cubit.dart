import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:road_guard/models/notification.dart';
import 'package:road_guard/sample_data/sample_data.dart';
import 'package:road_guard/utils/enums.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  FutureOr<void> fetchNotifications() async {
    try {
      if (isClosed) return null;

      // Simulating a delay as if fetching notifications
      // from a remote server or local database.
      emit(state.copyWith(status: CurrentStatus.loading));

      await Future.delayed(
        const Duration(seconds: 1),
        () {},
      ); // Simulated delay

      // After fetching notifications, emit the state with the loaded data.
      if (isClosed) return null;
      emit(
        state.copyWith(
          notifications: sampleNotifications,
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
