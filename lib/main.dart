import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:nerdvalorant/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nerdvalorant/pages/login/login.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/services/google_sign_in.dart';
import 'package:nerdvalorant/pages/dashboard/dashboard.dart';
import 'package:nerdvalorant/pages/onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([LocalStorage.init(), Firebase.initializeApp()]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
      ],
      child: const NerdValorantApp(),
    ),
  );
}

class NerdValorantApp extends StatelessWidget {
  const NerdValorantApp({Key? key}) : super(key: key);

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
  late bool alreadyViewed;

  @override
  void initState() {
    super.initState();

    setState(() => alreadyViewed = LocalStorage.readBool('seenIntro'));
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInProvider auth = Provider.of<GoogleSignInProvider>(context);

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (auth.googleUser == null) {
      return alreadyViewed ? const LoginPage() : const OnboardingPage();
    } else {
      return const DashboardPage();
    }
  }
}
