import 'dart:async';
import 'dart:developer';

import 'package:auth_repo/src/models/models.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:local_data/local_data.dart';
import 'package:net_source/net_source.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

/// Authentication statuses
enum AuthStatus {
  /// on startup, the authentication status of the user is unknown by default
  unknown,

  /// The status after a user is successfully authenticated
  authenticated,

  /// Refresh the current user data
  refresh,

  /// The status of a user after logging out or before logging in
  unauthenticated,

  /// The status of a user when his session has expired
  expired,

  /// The status o a guest user
  guest,
}

/// {@template auth_repo}
/// Repo for application authentication
/// {@endtemplate}
class AuthRepo {
  /// {@macro auth_repo}
  AuthRepo({
    required bool isDev,
    required SharedPrefs prefs,
    required LocalData db,
    required NetSource net,
    required FirebaseRepo firebaseRepo,
    //  SocketSource socket,
  })  : _prefs = prefs,
        _db = db,
        _net = net,
        _isDev = isDev,
        _firebaseRepo = firebaseRepo
  // _socket = socket
  {
    _progressSub = _net.uploadProgress.listen(_progressController.add);
    _firebaseRepo.listenForUser();

    _firebaseRepo.authStatus.listen(_controller.add);
  }

  // Shared preferences keys
  final String _keyId = 'user_id';
  final String _keyAppVersion = 'app_version';
  final String _keyToken = 'token';
  final String _keyCurrentToken = 'refreshToken';
  final String _keyTheme = 'theme';

  // final String _keyFCMToken = 'fcm_token';
  final String _keyLoggedIn = 'logged_in';
  final String _keyAppId = 'app_id';
  final String _keyDeviceId = 'device_id';

  // table names
  final String _tblUsers = 'users';

  final LocalData _db;
  final SharedPrefs _prefs;
  final NetSource _net;
  final bool _isDev;
  final FirebaseRepo _firebaseRepo;

  // final SocketSource _socket;

  final _themeController = StreamController<int>();

  Future<void> _initNetworkApi({String? token, String? refreshToken}) async {
    token ??= await _prefs.getString(_keyToken);
    refreshToken ??= await _prefs.getString(_keyCurrentToken);
    final deviceId = await _prefs.getString(_keyDeviceId);
    final appId = await _prefs.getString(_keyAppId);
    _net.init(
      deviceId: deviceId,
      appId: appId,
      token: token,
      refreshToken: refreshToken,
    );
  }

  /*************  ✨ Codeium Command ⭐  *************/

  /// Returns the device id used for network requests.
  ///
  /// This id is persisted in shared preferences and will be the same
  /// across app restarts. If the id does not exist, it will be generated
  /// and persisted. The id is used to identify the device in network
  /// requests, and is required for some features to work.
  ///
  /// The id is a UUID v4, and is generated using the [Uuid] package.
  ///
  /// which is used to initialize the network client.
// /******  28712767-ddff-4c98-9b80-9c1c94f302fc  *******/
  Future<String?> getDeviceId() async {
    const uuid = Uuid();
    var deviceId = await _prefs.getString(_keyDeviceId);
    var appId = await _prefs.getString(_keyAppId);
    if (deviceId == null) {
      deviceId = uuid.v4();
      await _prefs.set(_keyDeviceId, deviceId);
      // await connectChannels();
    }
    appId ??= '1efc7d35-7fd0-6000-a000-0123456789ac';
    await _prefs.set(_keyAppId, appId);
    final currentToken = await _prefs.getString(_keyCurrentToken);
    // final userId = await _prefs.getString(_keyId);
    // log('USER ID: $userId');
    final token = await _prefs.getString(_keyToken);
    _net.init(
      deviceId: deviceId,
      appId: appId,
      token: token,
      refreshToken: currentToken,
    );
    return deviceId;
  }

  /// Pipe function to check if token has been refreshed
  Future<dynamic> callService(Future<OpStatus?> Function() nextFunction) async {
    final response = await nextFunction.call();
    if (response?.code == 700) {
      log('Access Token Expired');
      refreshSession();
    }
    if (response?.code == 800) {
      log('Session Expired');
      refreshSession();
    }
    return response;
  }

  ///
  Stream<AuthStatus> get status async* {
    await getDeviceId();
    final isLoggedIn = await _checkLoggedIn();
    if (isLoggedIn) {
      yield AuthStatus.authenticated;
    } else {
      yield AuthStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  late StreamSubscription<int> _progressSub;
  final _controller = StreamController<AuthStatus>.broadcast();
  final _progressController = StreamController<int>.broadcast();

  /// The progress of an upload
  Stream<int> get uploadProgress async* {
    yield 0;
    yield* _progressController.stream;
  }

  Future<bool> _checkLoggedIn() async {
    await _saveAppVersion();
    final id = await _prefs.getString(_keyId);
    final token = await _prefs.getString(_keyToken);
    if (token == null) {
      await logOut();
      return false;
    }
    return id != null;
  }

  ///
  Stream<int> get theme async* {
    final appTheme = await _prefs.getInt(
      _keyTheme,
      defaultValue: 0,
    );

    yield appTheme!;

    yield* _themeController.stream;
  }

  /// Get the app theme
  Future<int> getTheme() async {
    return await _prefs.getInt(_keyTheme, defaultValue: 0) ?? 0;
  }

  /// Set the app theme
  Future<void> setTheme(int themeMode) async {
    await _prefs.set(_keyTheme, themeMode);
  }

  /// refreshes the session so a user is required to login before proceeding
  void refreshSession() => _controller.add(AuthStatus.expired);

  /// Function to logout
  Future<void> logOut() async {
    await _prefs.deleteValue(_keyId);
    await _prefs.deleteValue(_keyLoggedIn);
    await _db.deleteAll(_tblUsers);
    await _prefs.deleteValue(_keyToken);
    await _firebaseRepo.logOut();
    _controller.add(AuthStatus.unauthenticated);
  }

  /// Returns the logged in [User] object or null.
  Future<User?> getUser() async {
    final id = await _prefs.getString(_keyId);
    if (id == null) return null;
    final userData = await _db.getOne(_tblUsers, id);
    if (userData == null) return null;
    log('userData: $userData');
    return User.fromDbJson(userData);
  }

  /// Save app version into shared preferences
  Future<void> _saveAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    var isDev = 'Dev';

    if (!_isDev) isDev = '';
    await _prefs.set(
      _keyAppVersion,
      '${info.version}:${info.buildNumber}-$isDev',
    );
  }

  /*************  ✨ Codeium Command ⭐  *************/

  /// Gets the current app version.
  ///
  /// Returns the app version as a string, or null if the version is not found.
// /******  5ee5b586-82ca-4adc-9e41-ef679bbed768  *******/
  Future<String?> getAppVersion() async {
    final appVersion = await _prefs.getString(_keyAppVersion);
    return appVersion;
  }

// /*************  ✨ Codeium Command ⭐  *************/
  /// Closes the streams and cancels the subscriptions.
  ///
  /// This must be called when the [AuthRepo] is no longer needed, to free up
  /// resources.
// /******  798eda46-0cf3-4624-b347-295e8c524031  *******/
  void dispose() {
    _controller.close();
    _progressController.close();
    _progressSub.cancel();
  }
}
