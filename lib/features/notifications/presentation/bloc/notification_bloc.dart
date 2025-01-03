import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/notifications/domain/use_cases/fetch_notifications.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_cases/fetch_notifications_count.dart';
import 'package:letaskono_flutter/features/notifications/domain/use_cases/read_notification.dart';
part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final ReadNotification readNotificationUseCase = sl<ReadNotification>();
  final FetchNotifications fetchNotificationsUseCase = sl<FetchNotifications>();
  final FetchUnreadNotificationsCount fetchUnreadNotificationsUseCase =
      sl<FetchUnreadNotificationsCount>();

  NotificationBloc() : super(NotificationLoading()) {

    on<ReadNotificationEvent>((event, emit)async {
      emit(NotificationReadLoading());
      try{
        await readNotificationUseCase(event.id.toString());
        emit(NotificationReadSuccess());
      }catch (error){
        emit(NotificationReadFailed());
      }
    });


    on<FetchNotificationsEvent>((event, emit) async {
      final currentState = state;

      if (currentState is NotificationLoaded ||
          currentState is NotificationLoadingMore) {
        if (!event.isRefreshing &&
            !(currentState as NotificationLoaded).hasMore)
          return; // Prevent fetch if no more data

        emit(NotificationLoadingMore(
            (currentState as NotificationLoaded).notifications,
            currentState.currentPage,
            currentState.hasMore));

        try {
          final newNotifications = await fetchNotificationsUseCase(
              page: event.page); // Fetch notifications
          final hasMore =
              newNotifications.isNotEmpty; // Check if more data exists

          emit(NotificationLoaded(currentState.notifications + newNotifications,
              event.page, hasMore));
        } catch (error) {
          emit(NotificationFailed(error.toString()));
        }
      } else {
        // Initial load
        try {
          final notifications =
              await fetchNotificationsUseCase(page: event.page);
          emit(NotificationLoaded(
              notifications, event.page, notifications.isNotEmpty));
        } catch (error) {
          emit(NotificationFailed(error.toString()));
        }
      }
    });

    on<FetchUnreadNotificationsCountEvent>((event, emit) async {
      final count = await fetchUnreadNotificationsUseCase();
      emit(UnreadNotificationsCountFetched(count));
    });
  }
}
