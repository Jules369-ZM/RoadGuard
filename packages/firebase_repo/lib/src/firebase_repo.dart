import 'package:auth_repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_data/local_data.dart';
import 'package:net_source/net_source.dart';

/// {@template firebase_repo}
/// For firebase function
/// {@endtemplate}
class FirebaseRepo {
  /// {@macro firebase_repo}
  const FirebaseRepo({
    required LocalData db,
    required SharedPrefs prefs,
    required NetSource net,
    required bool isDev,
    required fire_auth.FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required AuthRepo authRepo,
  })  : _db = db,
        _prefs = prefs,
        _net = net,
        _isDev = isDev,
        _auth = auth,
        _googleSignIn = googleSignIn,
        _authRepo = authRepo;

  final LocalData _db;
  final SharedPrefs _prefs;
  final NetSource _net;
  final bool _isDev;
  final fire_auth.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final AuthRepo _authRepo;
}
