import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:nerdvalorant/services/google_sign_in.dart';
import 'package:nerdvalorant/mobile/local_notifications.dart';
import 'package:nerdvalorant/services/firebase_messaging.dart';
import 'package:nerdvalorant/pages/onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    MongoDatabase.connect(),
    Firebase.initializeApp(),
    LocalStorageService.init(),
    MobileAds.instance.initialize(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocalStorageService(), // alterar nome
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

    _initializeFirebaseMessaging();
    _checkNotifications();
  }

  _initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessageService>(context, listen: false)
        .initialize();
  }

  _checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false)
        .checkForNotifications();
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
      routes: Routes.list,
      initialRoute: Routes.initialRoute,
      navigatorKey: Routes.navigatorKey,
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
      return const HomePage();
    }
  }
}
