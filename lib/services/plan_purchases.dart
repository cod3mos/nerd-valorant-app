import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum AccessType { free, monthly, yearly }

class PlanPurchasesService extends ChangeNotifier {
  List<Offering> offering = [];
  String? accessType;

  PlanPurchasesService() {
    _listenPurchases();
  }

  Future _listenPurchases() async {
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      PurchaserInfo purchasesInfo = await Purchases.getPurchaserInfo();

      final entitlements = purchasesInfo.entitlements.active.values.toList();

      if (entitlements.isNotEmpty) {
        accessType = entitlements.first.productIdentifier;
      }

      notifyListeners();
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

  Future<bool> signPlan(Package plan) async {
    try {
      await Purchases.purchasePackage(plan);

      notifyListeners();

      return true;
    } catch (e) {
      notifyListeners();

      return false;
    }
  }
}
