import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:local_data/local_data.dart';
import 'package:road_guard/certficate_verifier.dart';
import 'package:road_guard/firebase_options.dart';
import 'package:road_guard/models/models.dart';
import 'package:road_guard/utils/strings.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

typedef AppBuilder = Future<Widget> Function(
  SharedPrefs prefs,
);
Future<void> bootstrap(
  AppBuilder builder, {
  AppEnv env = AppEnv.development,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  HttpOverrides.global = MyHttpOverrides();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  final prefs = await SharedPrefs.init();
  if (env == AppEnv.production) {
    baseUrl = 'http://${Config.prod().host}';
    flavor = '';
    host = Config.prod().host;
  } else if (env == AppEnv.development) {
    baseUrl = 'http://${Config.dev().host}';
    flavor = 'DEV';
    host = Config.dev().host;
  } else {
    baseUrl = 'http://${Config.staging().host}';
    flavor = 'STAGING';
    host = Config.staging().host;
  }
  runApp(
    await builder(
      prefs,
    ),
  );
}
