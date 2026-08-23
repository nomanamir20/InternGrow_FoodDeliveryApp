import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the most recent foreground notification received, so the UI
/// (a banner in the nav shell) can display it.
class NotificationBannerCubit extends Cubit<String?> {
  NotificationBannerCubit() : super(null);

  void show(String message) {
    emit(message);
  }

  void dismiss() {
    emit(null);
  }
}