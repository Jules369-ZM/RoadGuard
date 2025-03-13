
import 'package:road_guard/models/models.dart';

String baseUrl = 'http://${Config.dev().host}'; // UAT
String host = Config.dev().host; // UAT
String flavor = ''; // prod

Config config = Config.dev();


class Strings {
  static const loading = 'Loading...';
  static const submit = 'Submitting...';
  static const processing = 'Processing...';
  static const success = 'Success...';
  static const somethingWrong = 'Something went wrong...';
  static const noInternet = 'Turn on your data...';
  static const fillIn = 'Please fill in all fields';
  static const logingIn = 'Signing in...';
  static const logout = 'Signing out...';
  static const registering = 'Signing up...';
  static const coming = 'Coming soon...';
  static const unAuthenticated = 'UnAuthenticated...';
  static const unableToProcess =
      'Unfortunately, we are unable to process your request at the moment.';
  static const networkError = 'Network error, unable to connect';
}
