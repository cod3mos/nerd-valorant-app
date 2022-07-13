import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/routes/routes.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum AccessType { free, monthly, yearly }

class PlanPurchasesService extends ChangeNotifier {
  List<Offering> offering = [];
  String? accessType;
  bool waitingPayment = false;

  PlanPurchasesService() {
    _listenPurchases();
  }

  Future _listenPurchases() async {
    Purchases.addPurchaserInfoUpdateListener((_) async {
      waitingPayment = true;

      notifyListeners();

      PurchaserInfo purchasesInfo = await Purchases.getPurchaserInfo();

      final entitlements = purchasesInfo.entitlements.active.values.toList();

      if (entitlements.isNotEmpty) {
        accessType = entitlements.first.productIdentifier;
      }

      Timer(const Duration(milliseconds: 1500), () {
        waitingPayment = false;
        notifyListeners();
      });
    });
  }

  Future initialize() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(purchaseSecretApiKey);
  }

  Future<void> fetchOffers() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      Offering? currentOfferings = offerings.current;

      offering = currentOfferings == null ? [] : [currentOfferings];
    } on PlatformException {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> signPlan(Package plan) async {
    try {
      await Purchases.purchasePackage(plan);
    } on PlatformException catch (error) {
      if (error.code != '1' && error.code != '6') {
        final context = Routes.navigatorKey.currentContext!;

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível processar a sua solicitação, tente novamente em alguns minutos.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
