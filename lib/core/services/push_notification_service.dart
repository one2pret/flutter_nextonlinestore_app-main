import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/fcm_remote_datasource.dart';
import '../../presentation/order/pages/order_detail_page.dart';

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _fm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final FcmRemoteDatasource _remote = FcmRemoteDatasource();
  final AuthLocalDatasource _localAuth = AuthLocalDatasource();

  GlobalKey<NavigatorState>? _navigatorKey;
  bool _initialized = false;

  static const _androidChannel = AndroidNotificationChannel(
    'order_status',
    'Status Pesanan',
    description: 'Notifikasi perubahan status pesanan',
    importance: Importance.high,
  );

  void attachNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _fm.requestPermission(alert: true, badge: true, sound: true);

    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload;
        if (payload != null) _navigateToOrder(payload);
      },
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    if (await _localAuth.isLoggedIn()) {
      await registerTokenAfterLogin();
    }

    _fm.onTokenRefresh.listen((newToken) async {
      if (await _localAuth.isLoggedIn()) {
        await _remote.registerToken(newToken);
      }
    });

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    final initial = await _fm.getInitialMessage();
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleTap(initial));
    }
  }

  Future<void> registerTokenAfterLogin() async {
    final token = await _fm.getToken();
    if (token == null) return;
    if (kDebugMode) debugPrint('[FCM] Token: $token');
    await _remote.registerToken(token);
  }

  Future<void> clearTokenBeforeLogout() async {
    await _remote.registerToken(null);
    try {
      await _fm.deleteToken();
    } catch (e) {
      if (kDebugMode) debugPrint('[FCM] deleteToken failed: $e');
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final n = message.notification;
    if (n == null) return;
    await _local.show(
      n.hashCode,
      n.title,
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['orderId'],
    );
  }

  void _handleTap(RemoteMessage message) {
    final orderId = message.data['orderId'];
    if (orderId != null) _navigateToOrder(orderId);
  }

  void _navigateToOrder(String orderIdString) {
    final orderId = int.tryParse(orderIdString);
    final nav = _navigatorKey?.currentState;
    if (orderId == null || nav == null) return;
    nav.push(
      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: orderId)),
    );
  }
}
