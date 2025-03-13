import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/main/main.dart';
import 'package:road_guard/utils/internet/internet.dart';
import 'package:road_guard/utils/strings.dart';
import 'package:road_guard/utils/utils.dart';
import 'package:road_guard/widgets/loading_screen.dart';
import 'package:road_guard/widgets/widgets.dart';

bool _loading = false;

class InternetPage extends StatefulWidget {
  const InternetPage({super.key});
  static const id = 'InternetPage';

  /// The static route for InternetPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const InternetPage(),
    );
  }

  @override
  State<InternetPage> createState() => _InternetPageState();
}

class _InternetPageState extends State<InternetPage> {
  bool _onLoad = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showErrorSnackBar(context, message: Strings.noInternet);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_onLoad ? 'Refreshing Data' : 'Internet Connection'),
          automaticallyImplyLeading: false,
        ),
        body: InternetPageView(
          onLoad: (p0) {
            _onLoad = p0;
            if (mounted) setState(() {});
          },
        ),
      ),
    );
  }
}

/// Shows when there is no internet connection
class InternetPageView extends StatefulWidget {
  const InternetPageView({
    required this.onLoad,
    super.key,
    this.message = 'Sorry you have poor internet connection.',
  });
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool) onLoad;
  final String message;

  @override
  State<InternetPageView> createState() => _InternetPageViewState();
}

class _InternetPageViewState extends State<InternetPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {},
        child: _loading
            ? const LoadingScreen()
            : BlocConsumer<InternetCubit, InternetState>(
                listener: (context, internetState) async {
                  if (internetState.internetAccess == true) {
                    await checkAndRefreshData(context).then((value) {
                      log('done ######');
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  } else {
                    await context
                        .read<InternetCubit>()
                        .monitorNetworkConnection();
                  }
                },
                builder: (context, internetState) {
                  return Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            size: 80,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No Internet Connection',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '''Please check your internet settings and try again.''',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: getProportionateScreenHeight(24)),

                          AppButton(
                            text: 'Refresh',
                            icon: Icons.restart_alt,
                            onPressed: () async {
                              await checkAndRefreshData(context).then((value) {
                                log('done ######');
                                if (mounted) {
                                  setState(() {});
                                }
                              });
                              // context
                              // .read<InternetCubit>()
                              // .monitorNetworkConnection();
                            },
                          ),
                          // Text(widget.message),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  ///check internet connection and refresh data
  Future<bool?> checkAndRefreshData(BuildContext context) async {
    final internetCubit = context.read<InternetCubit>();
    await internetCubit.emitInternetConnected().then((value) async {
      final internetAccess = internetCubit.state.internetAccess;
      if (internetAccess) {
        if (context.mounted) {
          context.read<AuthBloc>().add(
                const AuthStatusChanged(AuthStatus.refresh),
              );
        }
        if (mounted) {
          setState(() {
            _loading = true;
            widget.onLoad(true);
          });
        }
        return Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _loading = false;
              widget.onLoad(false);
            });
          }
          if (context.mounted) {
            final status = context.read<AuthBloc>().state.status;
            if (status == AuthStatus.authenticated) {
              Navigator.pushAndRemoveUntil(
                context,
                MainPage.route(),
                (route) => false,
              );
            }
          }

          return true;
        });
      } else {
        log(Strings.noInternet);
        if (context.mounted) {
          showErrorSnackBar(context, message: Strings.noInternet);
        }
      }
    });
    return false;
  }
}
