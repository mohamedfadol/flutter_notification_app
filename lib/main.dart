import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_pp/firebase_options.dart';

import 'core/firebase_messageing_service.dart';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('firebaseMessagingBackgroundHandler ${message.messageId}');
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await initLocalNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseMessagingService().initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
Future<void> initLocalNotification()async{
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid,);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void requestPermissions() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(alert: true,announcement: false,badge: true,carPlay: false,criticalAlert: false,provisional: false,sound: true,);
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
        print('user granted permission');
    } else {
      print('User declined or has not yet granted permission');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification App'),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: TextButton(
                onPressed: () async{
                  await FirebaseMessaging.instance.getToken().then((token){
                    print('token $token');
                  });
                },
                child: Text('get token'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
