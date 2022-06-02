import 'package:flutter/material.dart';
import 'package:nerdvalorant/routes/routes.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.init();

  runApp(const NerdValorantApp());
}

class NerdValorantApp extends StatelessWidget {
  const NerdValorantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute(),
      routes: Routes.list,
      navigatorKey: Routes.navigatorKey,
    );
  }

  String initialRoute() {
    return LocalStorage.readBool('seenIntro') ? '/login' : '/onboarding';
  }
}
