import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/notification/notification_event.dart';
import 'package:flutter_web_fe/blocs/notification/notification_state.dart';
import 'package:flutter_web_fe/core/data/repositories/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc({required this.notificationService})
      : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final notifications = await notificationService.fetchNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      emit(NotificationError(message: e.toString()));
    }
  }
}
