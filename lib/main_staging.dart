import 'package:firebase_repo/firebase_repo.dart';
import 'package:local_data/local_data.dart';
import 'package:net_source/net_source.dart';
import 'package:notifications_repo/notifications_repo.dart';
import 'package:permission_client/permission_client.dart';
import 'package:road_guard/app/app.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/bootstrap.dart';
import 'package:road_guard/models/models.dart';
import 'package:road_guard/utils/strings.dart';

void main() {
  config = Config.staging();
  bootstrap((prefs) async {
    final token = await prefs.getString('token');

    final db = await LocalData.init(
      dbName: config.dbName,
      initialScript: config.initScript,
      migrations: config.migrations,
    );
    final net = NetSource(
      baseUrl: config.baseUrl,
      host: config.host,
      token: token,
    );
    final firebaseRepo = FirebaseRepo(
      prefs: prefs,
      db: db,
      net: net,
      firebaseAuth: null,
      googleSignIn: null,
    );
    final authRepo = AuthRepo(
      prefs: prefs,
      db: db,
      net: net,
      isDev: config.environment == AppEnv.development,
      firebaseRepo: firebaseRepo,
    );

    const permissionClient = PermissionClient();
    final notificationRepo = NotificationsRepo(
      prefs: prefs,
      net: net,
      permissionClient: permissionClient,
    );
    return App(
      authRepo: authRepo,
      firebaseRepo: firebaseRepo,
      permissionClient: permissionClient,
      notificationsRepo: notificationRepo,
    );
  });
}
