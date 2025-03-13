
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:road_guard/utils/strings.dart';

part 'internet_state.dart';

///Check the internet connection of the device
class InternetCubit extends Cubit<InternetState> {
  ///
  InternetCubit({required this.connectivity}) : super(const InternetState()) {
    monitorNetworkConnection();
  }

  Future<void> checkServer() async {
    try {
      final result = await InternetAddress.lookup(host);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        emit(state.copyWith(serverIsUp: true));
      } else {
        emit(state.copyWith(serverIsUp: false));
      }
    } on Exception catch (_) {
      emit(state.copyWith(serverIsUp: false));
    }
  }

  ///Discover network Connectivity
  final Connectivity connectivity;

  bool hasInternetAccess() => state.internetAccess;

  ///
  StreamSubscription<List<ConnectivityResult>>? connectivityStreamSubscription;
  @override
  Future<void> close() {
    connectivityStreamSubscription?.cancel();
    return super.close();
  }

  /// monitors connection
  Future<void> monitorNetworkConnection() async {

    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.wifi)) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
        emitInternetConnected();
      } else if (connectivityResult.contains(ConnectivityResult.none)) {
        emitInternetDisconnected();
      }
    });
  }

  ///connected state
  Future<void> emitInternetConnected([
    ConnectionType connectionTyp_ = ConnectionType.mobile,
  ]) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      await checkServer();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        emit(
          state.copyWith(
            navigate: true,
            internetAccess: true,
            connectionType: connectionTyp_,
            internetStatus: InternetStatus.connected,
          ),
        );
      } else {
        emitInternetDisconnected();
      }
    } on SocketException catch (e) {
      log(e.toString());
      emitInternetDisconnected();
    }
  }

  ///connected state
  Future<void> emitServerUp([
    ConnectionType connectionTyp_ = ConnectionType.mobile,
  ]) async {
    try {
      final result = await InternetAddress.lookup(host);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        emit(
          state.copyWith(
            navigate: true,
            internetAccess: true,
            connectionType: connectionTyp_,
            internetStatus: InternetStatus.connected,
          ),
        );
      } else {
        emitInternetDisconnected();
      }
    } on SocketException catch (e) {
      log(e.toString());
      emitInternetDisconnected();
    }
  }

  ///disconnected state
  void emitInternetDisconnected() {
    emit(
      state.copyWith(
        internetAccess: false,
        navigate: false,
        connectionType: ConnectionType.none,
        internetStatus: InternetStatus.disconnected,
      ),
    );
  }
}

///contains [wifi], [mobile] and [none],
///Network connection type
enum ConnectionType {
  /// wifi ConnectionType
  wifi,

  /// mobile ConnectionType
  mobile,

  /// no ConnectionType
  none,
}
