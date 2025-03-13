import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

class ContactUtil {
  static Future<Contact?> getContact(BuildContext context) async {
    final contact = await FlutterNativeContactPicker().selectContact();
    return contact;
  }
}
