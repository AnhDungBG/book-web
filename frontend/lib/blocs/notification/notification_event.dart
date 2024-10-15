import 'package:flutter_web_fe/core/data/models/notification_model.dart';

abstract class NotificationEvent {}

class FetchNotificationsEvent extends NotificationEvent {}

abstract class NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
  });
}
