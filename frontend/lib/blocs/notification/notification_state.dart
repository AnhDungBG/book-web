import 'package:flutter_web_fe/blocs/notification/notification_event.dart';
import 'package:flutter_web_fe/core/data/models/notification_model.dart';

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  @override
  // ignore: overridden_fields
  final List<NotificationModel> notifications;

  NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});
}
