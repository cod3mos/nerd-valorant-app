import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nerdvalorant/widgets/rate_app_modal_item.dart';
import 'package:provider/provider.dart';
import 'package:nerdvalorant/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nerdvalorant/pages/home/home.dart';
import 'package:nerdvalorant/pages/login/login.dart';
import 'package:nerdvalorant/DB/mongo_database.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvalorant/services/plan_purchases.dart';
import 'package:nerdvalorant/services/google_sign_in.dart';
import 'package:nerdvalorant/mobile/local_notifications.dart';
import 'package:nerdvalorant/services/firebase_messaging.dart';
import 'package:nerdvalorant/pages/onboarding/onboarding.dart';
import 'package:rate_my_app/rate_my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    MongoDatabase.connect(),
    Firebase.initializeApp(),
    MobileAds.instance.initialize(),
    LocalStorageService.initialize(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlanPurchasesService(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalStorageService(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationService(
            context.read<LocalStorageService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        Provider(
          create: (context) => FirebaseMessageService(
            context.read<NotificationService>(),
            context.read<LocalStorageService>(),
          ),
        ),
      ],
      child: const NerdValorantApp(),
    ),
  );
}

class NerdValorantApp extends StatefulWidget {
  const NerdValorantApp({Key? key}) : super(key: key);

  @override
  State<NerdValorantApp> createState() => _NerdValorantAppState();
}

class _NerdValorantAppState extends State<NerdValorantApp> {
  @override
  void initState() {
    super.initState();

    _initializeServices();
  }

  _initializeServices() async {
    await Future.wait([
      Provider.of<PlanPurchasesService>(context, listen: false).initialize(),
      Provider.of<FirebaseMessageService>(context, listen: false).initialize(),
      Provider.of<NotificationService>(context, listen: false).checkForNotify(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appBarColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: appBarColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const VerifyAuth(),
      navigatorKey: Routes.navigatorKey,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

class VerifyAuth extends StatefulWidget {
  const VerifyAuth({Key? key}) : super(key: key);

  @override
  State<VerifyAuth> createState() => _VerifyAuthState();
}

class _VerifyAuthState extends State<VerifyAuth> {
  late User? googleUser;
  late bool alreadyViewed;

  @override
  void initState() {
    super.initState();

    context.read<LocalStorageService>().readSeenIntro();
  }

  checkLocalStorageService() {
    googleUser = context.watch<GoogleSignInProvider>().googleUser;
    alreadyViewed = context.watch<LocalStorageService>().alreadyViewed;
  }

  @override
  Widget build(BuildContext context) {
    checkLocalStorageService();

    if (googleUser == null) {
      return alreadyViewed ? const LoginPage() : const OnboardingPage();
    } else {
      return RateAppModalItem(
        builder: (rateMyApp) {
          return const HomePage();
        },
      );
    }
  }
}
