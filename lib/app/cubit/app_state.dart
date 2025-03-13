part of 'app_cubit.dart';

enum AppStatus { initial, loading, success, error }

enum DownloadStatus { initial, downloading, loading, complete, error }

class AppState extends Equatable {
  const AppState({
    this.message = '',
    this.status = AppStatus.initial,
    this.downloadStatus = DownloadStatus.initial,
    this.transactions = const [],
    this.balance = 0,
    this.progress = 0,
    this.data,
  });

  final String message;
  final AppStatus status;
  final DownloadStatus downloadStatus;
  final JsonMap? data;
  final double balance;
  final List<JsonMap> transactions;
  final double progress;

  AppState copyWith({
    String? message,
    AppStatus? status,
    DownloadStatus? downloadStatus,
    JsonMap? data,
    List<JsonMap>? transactions,
    double? balance,
    double? progress,
  }) {
    return AppState(
      status: status ?? this.status,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      message: message ?? this.message,
      data: data ?? this.data,
      transactions: transactions ?? this.transactions,
      balance: balance ?? this.balance,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
        status,
        downloadStatus,
        data,
        message,
        balance,
        progress,
        transactions,
      ];
}
