import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:flutter/material.dart';
import 'package:notifications_repo/notifications_repo.dart';
import 'package:permission_client/permission_client.dart';
import 'package:road_guard/app/cubit/app_cubit.dart';
import 'package:road_guard/app/theme/theme.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/l10n/l10n.dart';
import 'package:road_guard/login/login.dart';
import 'package:road_guard/main/main.dart';
import 'package:road_guard/start/start.dart';
import 'package:road_guard/utils/constants.dart';
import 'package:road_guard/utils/internet/internet.dart';
import 'package:road_guard/utils/utils.dart';

class App extends StatelessWidget {
  const App({
    required this.authRepo,
    required this.firebaseRepo,
    required this.permissionClient,
    required this.notificationsRepo,
    super.key,
  });
  final AuthRepo authRepo;
  final FirebaseRepo firebaseRepo;
  final PermissionClient permissionClient;
  final NotificationsRepo notificationsRepo;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: firebaseRepo),
        RepositoryProvider.value(value: notificationsRepo),
        RepositoryProvider.value(value: permissionClient),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit(authRepo)),
          BlocProvider(
            create: (context) => InternetCubit(
              connectivity: Connectivity(),
            )..monitorNetworkConnection(),
          ),
          BlocProvider(create: (context) => AuthBloc(authRepo, context.read())),
          BlocProvider(create: (context) => AppCubit(firebaseRepo, authRepo)),
        ],
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    context.watch<AuthBloc>();
    SizeConfig().init(context);
    context.watch<InternetCubit>().monitorNetworkConnection();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.expired ||
            state.status == AuthStatus.unauthenticated) {
          navKey.currentState
              ?.pushAndRemoveUntil(LoginPage.route(), (_) => false);
        } else if (state.status == AuthStatus.authenticated) {
          navKey.currentState
              ?.pushAndRemoveUntil(MainPage.route(), (_) => false);
        } else {
          navKey.currentState
              ?.pushAndRemoveUntil(LoginPage.route(), (_) => false);
        }
      },
      child: MaterialApp(
        title: 'RoadGuard',
        navigatorKey: navKey,
        debugShowCheckedModeBanner: false,
        theme: const AppTheme().themeData,
        darkTheme: const AppDarkTheme().themeData,
        themeMode: context.watch<ThemeCubit>().state.mode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const StartPage(),
      ),
    );
  }
}
