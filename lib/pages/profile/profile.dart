import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/keys/links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/profile/styles.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/services/plan_purchases.dart';
import 'package:nerdvalorant/services/google_sign_in.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nerdvalorant/pages/profile/widgets/profile_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  bool isUserPremium = false;

  @override
  void initState() {
    super.initState();

    user = context.read<GoogleSignInProvider>().googleUser!;
  }

  checkPlanPurchasesService() {
    final accessType = context.watch<PlanPurchasesService>().accessType;

    if (accessType != null) {
      setState(() => isUserPremium = accessType.isNotEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    checkPlanPurchasesService();

    void logout() async {
      try {
        await context.read<GoogleSignInProvider>().logoutOfAllAccounts();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
    }

    String makeImageWithInitials() {
      List<String> names = user.displayName!.split(' ');

      return names[0][0] + names[1][0];
    }

    void goToPage({route, data = ''}) {
      Navigator.pushNamed(context, route, arguments: data);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(screenBackground),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width(5),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Informações do Perfil',
                      style: titleStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (user.photoURL != null)
                      CircleAvatar(
                        radius: ScreenSize.width(8),
                        backgroundImage: CachedNetworkImageProvider(
                          user.photoURL!,
                        ),
                        backgroundColor: blackColor,
                      )
                    else
                      CircleAvatar(
                        radius: ScreenSize.width(8),
                        backgroundColor: blackColor,
                        child: Text(
                          makeImageWithInitials(),
                          style: avatarUserStyle,
                        ),
                      ),
                    Text(
                      user.email.toString(),
                      style: emailStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Assinante ',
                                style: textPremiumStyle,
                              ),
                              TextSpan(
                                text:
                                    isUserPremium ? 'Radiante ' : 'Sem Patente',
                                style: isUserPremium
                                    ? textPremiumBoldStyle
                                    : textPremiumStyle,
                              ),
                            ],
                          ),
                        ),
                        if (isUserPremium)
                          Icon(
                            Ionicons.diamond_outline,
                            color: blueColor,
                            size: ScreenSize.adaptiveFontSize(3.5),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF38393F),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileButton(
                        icon: Ionicons.card_outline,
                        text: 'Plano de assinatura',
                        onTouch: () => goToPage(route: '/subscriptions'),
                      ),
                      ProfileButton(
                        icon: Ionicons.person_outline,
                        text: 'Detalhes da conta',
                        onTouch: () => goToPage(route: '/settings', data: user),
                      ),
                      ProfileButton(
                        icon: Ionicons.notifications_outline,
                        text: 'Notificações',
                        onTouch: () => goToPage(route: '/notifications'),
                      ),
                      ProfileButton(
                        icon: Ionicons.heart_outline,
                        text: 'Apoie este projeto',
                        onTouch: () => openLink(supportUs),
                      ),
                      ProfileButton(
                        icon: Ionicons.logo_google_playstore,
                        text: 'Ajude-nos avaliando este app',
                        onTouch: () => openLink(hateMyAppOnPlayStore),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF38393F),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileButton(
                        icon: Ionicons.reader_outline,
                        text: 'Termos & Condições',
                        onTouch: () => openLink('$baseLink/terms-coditions'),
                      ),
                      ProfileButton(
                        icon: Ionicons.lock_closed_outline,
                        text: 'Políticas de privacidade',
                        onTouch: () => openLink('$baseLink/privacy-policy'),
                      ),
                      ProfileButton(
                        icon: Ionicons.logo_instagram,
                        text: 'Siga-nos no Instagram',
                        onTouch: () => openLink(instagram),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF38393F),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileButton(
                        icon: Ionicons.log_out_outline,
                        text: 'Sair da conta',
                        onTouch: logout,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openLink(link) async {
    final Uri uri = Uri.parse(link);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'link inválido';
    }
  }
}
