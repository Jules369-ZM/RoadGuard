part of 'internet_cubit.dart';

enum InternetStatus { connected, disconnected, unkown }

////
class InternetState extends Equatable {
  ////
  const InternetState({
    this.connectionType = ConnectionType.none,
    this.internetStatus = InternetStatus.unkown,
    this.internetAccess = false,
    this.navigate = false,
    this.serverIsUp = false,
  });

  final InternetStatus internetStatus;

  final ConnectionType connectionType;

  final bool internetAccess;
  final bool navigate;
  final bool serverIsUp;

  InternetState copyWith({
    InternetStatus? internetStatus,
    ConnectionType? connectionType,
    bool? internetAccess,
    bool? navigate,
    bool? serverIsUp,
  }) {
    return InternetState(
      internetStatus: internetStatus ?? this.internetStatus,
      connectionType: connectionType ?? this.connectionType,
      internetAccess: internetAccess ?? this.internetAccess,
      navigate: navigate ?? this.navigate,
      serverIsUp: serverIsUp ?? this.serverIsUp,
    );
  }

  @override
  List<Object> get props =>
      [internetAccess, internetStatus, connectionType, navigate, serverIsUp];
}
