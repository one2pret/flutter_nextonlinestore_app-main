import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/services/push_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/address_remote_datasource.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/banner_remote_datasource.dart';
import 'data/datasources/cart_remote_datasource.dart';
import 'data/datasources/category_remote_datasource.dart';
import 'data/datasources/order_remote_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/shipping_remote_datasource.dart';
import 'firebase_options.dart';
import 'presentation/address/bloc/address_bloc.dart';
import 'presentation/auth/bloc/login_bloc.dart';
import 'presentation/auth/bloc/register_bloc.dart';
import 'presentation/cart/bloc/cart_bloc.dart';
import 'presentation/checkout/bloc/checkout_bloc.dart';
import 'presentation/checkout/bloc/shipping_bloc.dart';
import 'presentation/order/bloc/order_bloc.dart';
import 'presentation/home/bloc/banner_bloc.dart';
import 'presentation/home/bloc/category_bloc.dart';
import 'presentation/home/bloc/product_bloc.dart';
import 'presentation/product/bloc/product_detail_bloc.dart';
import 'presentation/profile/bloc/profile_bloc.dart';
import 'presentation/splash/splash_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  PushNotificationService.instance.attachNavigatorKey(navigatorKey);
  PushNotificationService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(AuthRemoteDatasource())),
        BlocProvider(create: (_) => RegisterBloc(AuthRemoteDatasource())),
        BlocProvider(create: (_) => BannerBloc(BannerRemoteDatasource())),
        BlocProvider(create: (_) => CategoryBloc(CategoryRemoteDatasource())),
        BlocProvider(create: (_) => ProductBloc(ProductRemoteDatasource())),
        BlocProvider(
            create: (_) => ProductDetailBloc(ProductRemoteDatasource())),
        BlocProvider(create: (_) => CartBloc(CartRemoteDatasource())),
        BlocProvider(
            create: (_) => AddressBloc(AddressRemoteDatasource())),
        BlocProvider(
            create: (_) => ShippingBloc(ShippingRemoteDatasource())),
        BlocProvider(
            create: (_) => CheckoutBloc(OrderRemoteDatasource())),
        BlocProvider(create: (_) => OrderBloc(OrderRemoteDatasource())),
        BlocProvider(
            create: (_) =>
                ProfileBloc(AuthRemoteDatasource(), AuthLocalDatasource())),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Next Online Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const SplashPage(),
      ),
    );
  }
}
