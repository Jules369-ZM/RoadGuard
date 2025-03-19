import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:road_guard/models/notification.dart';
import 'package:road_guard/utils/enums.dart';
part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  FutureOr<void> fetchNotifications() {
    try {
      if (isClosed) return null;
      emit(state.copyWith(status: CurrentStatus.loading));
    } catch (e) {
      if (isClosed) return null;
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
  }
}
