// ignore_for_file: lines_longer_than_80_chars

import 'package:road_guard/models/notification.dart';

List<Notification> sampleNotifications = [
  Notification(
    id: '1',
    title: 'Vehicle Registration Reminder',
    message:
        'Your vehicle registration is expiring soon. Please renew it before the due date.',
    body:
        'Your vehicle registration for car XYZ123 is due for renewal in 5 days. Visit the RTSA website to complete the renewal.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isRead: false,
  ),
  Notification(
    id: '2',
    title: 'Road Safety Alert',
    message: 'Stay alert for road safety updates.',
    body:
        'Due to adverse weather conditions, road safety is compromised. Ensure to drive cautiously and avoid non-essential travel.',
    timestamp: DateTime.now().subtract(const Duration(hours: 12)),
    isRead: true,
  ),
  Notification(
    id: '3',
    title: 'Traffic Violation Notification',
    message: 'You have been fined for a traffic violation.',
    body:
        'A fine has been imposed for speeding. You can pay the fine online through the RTSA portal.',
    timestamp: DateTime.now().subtract(const Duration(days: 5)),
    isRead: false,
  ),
  Notification(
    id: '4',
    title: 'Vehicle Inspection Reminder',
    message: 'Your vehicle inspection is due.',
    body:
        'Please remember to schedule a vehicle inspection within the next 7 days to ensure roadworthiness.',
    timestamp: DateTime.now().subtract(const Duration(days: 10)),
    isRead: false,
  ),
  Notification(
    id: '5',
    title: 'New Traffic Regulations',
    message: 'Important updates on traffic regulations have been issued.',
    body:
        'RTSA has announced new speed limits for highways. Make sure to familiarize yourself with the new regulations.',
    timestamp: DateTime.now().subtract(const Duration(days: 30)),
    isRead: true,
  ),
  Notification(
    id: '6',
    title: 'License Renewal Reminder',
    message: 'Your driver’s license is about to expire.',
    body:
        'Don’t forget to renew your driver’s license. You can renew it online through the RTSA website.',
    timestamp: DateTime.now().subtract(const Duration(days: 20)),
    isRead: true,
  ),
  Notification(
    id: '7',
    title: 'RTSA App Update Available',
    message: 'A new version of the RTSA app is available.',
    body:
        'Please update your RTSA app to the latest version to access new features and improvements.',
    timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    isRead: false,
  ),
  Notification(
    id: '8',
    title: 'Traffic Congestion Alert',
    message: 'Heavy traffic is expected in your area.',
    body:
        'Due to roadworks, heavy traffic is anticipated on the M1. Consider alternative routes to avoid delays.',
    timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    isRead: false,
  ),
  Notification(
    id: '9',
    title: 'Public Transport Schedule Update',
    message: 'Changes have been made to the public transport schedule.',
    body:
        'Due to upcoming roadworks, the bus schedule has been updated. Check the new schedule on the RTSA app.',
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
    isRead: true,
  ),
  Notification(
    id: '10',
    title: 'Road Closure Notice',
    message: 'A major road will be closed for maintenance.',
    body:
        'The Kafue Road will be closed for maintenance from 10th to 15th. Please plan your routes accordingly.',
    timestamp: DateTime.now().subtract(const Duration(days: 7)),
    isRead: false,
  ),
];
