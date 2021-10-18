import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:live_streams_app/features/live_stream/live_stream.dart';
import 'package:live_streams_app/services/local_notification_service.dart';
import 'data/repositories/authentication_repository.dart';
import 'features/app/app.dart';
import 'features/personal_informations/view/personal_informations_page.dart';
import 'features/verify/view/verify_page.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    final routeFromMessage = message.data['route'];
    if (routeFromMessage == 'verify') {
      final id = message.data['id'];
      Navigator.of(navigatorKey.currentState!.context)
          .push<void>(VerifyPage.route(id));
    } else if (routeFromMessage == 'live_stream') {
      Navigator.of(navigatorKey.currentState!.context)
          .push<void>(LiveStreamPage.route());
    }  else if (routeFromMessage == 'personal_information') {
        Navigator.of(navigatorKey.currentState!.context).push<void>(PersonalInformationsPage.route());
      }
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  final authenticationRepository = AuthenticationRepository();
  // await authenticationRepository.user.first;
  runApp(App(authenticationRepository: authenticationRepository));
}

void navigatorTo(String page) {
  var rootContext = navigatorKey.currentState?.context;
  Navigator.of(rootContext!).pushNamed(page);
}
