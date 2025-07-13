import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/bloc/submitbloc/report_bloc.dart';
import 'package:pungutinid/bloc/subscriptionbloc/subscription_bloc.dart';
import 'package:pungutinid/bloc/usersubscriptionbloc/userSubsciption_bloc.dart';
import 'package:pungutinid/component/screen/splashscreen.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/service/authService.dart';
import 'package:pungutinid/core/service/reportService.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';
import 'package:pungutinid/page/auth/login.dart';
import 'package:pungutinid/page/auth/register.dart';
import 'package:pungutinid/page/dashboard/buyerDashboard.dart';
import 'package:pungutinid/page/dashboard/citizenDashboard.dart';
import 'package:pungutinid/page/dashboard/dashboard.dart';
import 'package:pungutinid/page/location/LocationPage.dart' as provider_location;
import 'package:pungutinid/page/location/BuyerLocationPage.dart' as buyer_location;
import 'package:pungutinid/page/profile/editProfile.dart';
import 'package:pungutinid/page/profile/profile.dart';
import 'package:pungutinid/page/subscription/AddSubscriptionPage.dart';
import 'package:pungutinid/page/subscription/ProviderSubscriptionPage.dart';
import 'package:pungutinid/page/subscription/SubscriptionWastePage.dart';
import 'package:pungutinid/page/subscription/UserSubscriptionPage.dart';
import 'package:pungutinid/page/transaction/CreateTransactionPage.dart';
import 'package:pungutinid/page/transaction/MyTransactionPage.dart';
import 'package:pungutinid/page/transaction/WasteSalesPage.dart';
import 'package:pungutinid/page/wastereport/PostReportPage.dart';
import 'package:pungutinid/page/wastereport/WasteReportPage.dart';

void main() {
  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(authService),
        ),
        BlocProvider(
          create: (_) => ReportBloc(ReportService()),
        ),
        BlocProvider(
          create: (_) => SubscriptionBloc(SubscriptionService())
        ),
        BlocProvider(
          create: (_) => UserSubscriptionBloc(SubscriptionService()))
      ],
      child: const MyApp(),
    ),
  );
}

class LoggingNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('[NAV] PUSH: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('[NAV] POP: ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint('[NAV] REMOVE: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint('[NAV] REPLACE: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pungutin.id',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Poppins',
      ),
      home: const Splashscreen(),
      routes: {
        '/buyerDashboard': (context) => BuyerDashboardScreen(),
        '/providerDashboard': (context) => DashboardScreen(),
        '/citizenDashboard': (context) => CitizenDashboardScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
        '/editProfile': (context) => const EditProfilePage(),
        '/locationGet': (context) => buyer_location.BuyerLocationPage(),
        '/locationCreate': (context) => provider_location.LocationPage(),
        '/wasteReport': (context) => WasteReportPage(),
        '/postReport': (context) => PostReportPage(),
        '/subscribe': (context) => SubscriptionWastePage(),
        '/mySubscription': (context) => const UserSubscriptionPage(),
        '/addSubscription': (context) => const AddSubscriptionPage(),
        '/providerSubscription': (context) => const ProviderSubscriptionPage(),
        '/citizenTransaction': (context) => CreateTransactionPage(),
        '/myTransaction': (context) => MyTransactionsPage(),
        '/buyerTransaction': (context) => WasteSalesPage(),
      },
      navigatorObservers: [LoggingNavigatorObserver()],
    );
  }
}