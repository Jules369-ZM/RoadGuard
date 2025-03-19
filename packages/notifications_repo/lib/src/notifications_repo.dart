import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_data/local_data.dart';
import 'package:net_source/net_source.dart';
import 'package:notifications_repo/src/models/models.dart';
import 'package:permission_client/permission_client.dart';

/// {@template notifications_repo}
/// Repository responsible for notifications
/// {@endtemplate}
class NotificationsRepo {
  /// {@macro notifications_repo}
  NotificationsRepo({
    required SharedPrefs prefs,
    // required SocketSource socket,
    required PermissionClient permissionClient,
    required NetSource net,
  })  : _prefs = prefs,
        // _socket = socket,
        _permissionClient = permissionClient,
        _net = net;

  // Shared preferences keys
  final String _keyLastNotification = 'last_notification';
  final String _keyNotificationEnabled = 'notification_enabled';

  final SharedPrefs _prefs;
  // final SocketSource _socket;
  final PermissionClient _permissionClient;
  final NetSource _net;

  final _controller = StreamController<JsonMap>.broadcast();

  ///
  bool notificationsEnabled = false;

  ///
  static String? selectedNotificationPayload;

  ///
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialized in the `main` function
 static final StreamController<NotificationResponse> selectNotificationStream =
      StreamController<NotificationResponse>.broadcast();

  ///
  static const MethodChannel platform =
      MethodChannel('dexterx.dev/flutter_local_notifications_example');

  ///
  static const String portName = 'notification_send_port';

  /// A notification action which triggers a url launch event
  static const String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  static const String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static const String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  /// Stream of [JsonMap] which will emit the current user when
  /// the authentication state changes.
  Stream<JsonMap> get notification async* {
    yield* _controller.stream;
  }

  /// Returns the last notification in [JsonMap] object or null.
  Future<JsonMap?> getLastNotification() async {
    final stringData = await _prefs.getString(_keyLastNotification);
    if (stringData == null) return null;
    final notificationData = jsonDecode(stringData);
    return notificationData as JsonMap?;
  }

  /// Get the latest app update details
  Future<UpdateDetails?> checkUpdate(String platform) async {
    try {
      final response = await _net.get('Auth/GetAppUpdates?name=$platform');
      if (response.isSuccessful()) {
        return UpdateDetails.fromJson(
          UpdateDetails.filter(response.data as JsonMap),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Toggles the notifications based on the [enable].
  ///
  /// When [enable] is true, request the notification permission if not granted
  /// and marks the notification setting as enabled. Subscribes the user to
  /// notifications related to user's categories preferences.
  ///
  /// When [enable] is false, marks notification setting as disabled and
  /// unsubscribes the user from notifications related to user's categories
  /// preferences.
  Future<void> toggleNotifications({required bool enable}) async {
    try {
      // Request the notification permission when turning notifications on.
      if (enable) {
        // Find the current notification permission status.
        final permissionStatus = await _permissionClient.notificationsStatus();

        // Navigate the user to permission settings
        // if the permission status is permanently denied or restricted.
        if (permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          await _permissionClient.openPermissionSettings();
          return;
        }

        // Request the permission if the permission status is denied.
        if (permissionStatus.isDenied) {
          final updatedPermissionStatus =
              await _permissionClient.requestNotifications();
          if (!updatedPermissionStatus.isGranted) {
            return;
          }
        }
      }

      // Update the notifications enabled in Storage.
      await _prefs.set(_keyNotificationEnabled, enable);
    } catch (error, stackTrace) {
      log('$error');
      log('$stackTrace');
    }
  }

  ///
  Future<void> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      notificationsEnabled = granted;
    }
  }
///
  static Future<void> initialize(
    void Function(NotificationResponse)? notificationTapBackground,
  ) async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinNotificationCategories = <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      ),
    ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinNotificationCategories,
    );
    final initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotificationStream.add,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    final notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    // String initialRoute = HomePage.routeName;
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      // initialRoute = SecondPage.routeName;
    }
  }
}
