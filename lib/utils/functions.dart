import 'dart:developer';

import 'package:country_phone_validator/country_phone_validator.dart';

// Function to get greeting based on the time of day
String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

bool phoneValidator(String? value, String phoneNumber, String dialCode) {
  if (value == null || value.isEmpty) {
    return false;
  }

  // Ensure dial code starts with '+'
  final formattedDialCode = dialCode.startsWith('+') ? dialCode : '+$dialCode';

  // Remove dial code and non-digit characters
  final cleanNumber = phoneNumber
      .replaceAll(formattedDialCode, '')
      .replaceAll(RegExp(r'[^\d]'), '');

  final isValid =
      CountryUtils.validatePhoneNumber(cleanNumber, formattedDialCode);

  log('Validation Result: $isValid');

  return isValid;
}

// Helper function to normalize dial code
String normalizeDialCode(String dialCode) {
  return dialCode.startsWith('+') ? dialCode : '+$dialCode';
}

String removeDialCode(String phoneNumber, String dialCode) {
  if (phoneNumber.startsWith(dialCode)) {
    return phoneNumber.substring(dialCode.length).trim();
  }
  return phoneNumber;
}

String getNetworkProvider(String phoneNumber1) {
  // Remove any non-digit characters (e.g., spaces, '+', etc.)
  var phoneNumber = phoneNumber1.replaceAll(RegExp(r'[^\d]'), '');

  // Ensure the number is in the correct format (starts with "26" or "0")
  if (phoneNumber.startsWith('260')) {
    phoneNumber = phoneNumber.substring(3); // Remove the "260" country code
  }

  if (!phoneNumber.startsWith('0')) {
    phoneNumber = '0$phoneNumber'; // Prepend "0" if missing
  }

  // Define Zambian network provider prefixes
  const airtelPrefixes = ['097', '077']; // Airtel
  const mtnPrefixes = ['096', '076']; // MTN
  const zamtelPrefixes = ['095', '021', '075']; // Zamtel
  const zedMobilePrefixes = ['098', '078']; // ZedMobile

  // Check the prefix against each provider
  for (final prefix in airtelPrefixes) {
    if (phoneNumber.startsWith(prefix)) {
      return 'Airtel';
    }
  }

  for (final prefix in mtnPrefixes) {
    if (phoneNumber.startsWith(prefix)) {
      return 'MTN';
    }
  }

  for (final prefix in zamtelPrefixes) {
    if (phoneNumber.startsWith(prefix)) {
      return 'Zamtel';
    }
  }

  for (final prefix in zedMobilePrefixes) {
    if (phoneNumber.startsWith(prefix)) {
      return 'ZedMobile';
    }
  }
  // If no match is found
  return 'Unknown Network';
}
