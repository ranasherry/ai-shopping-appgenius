import 'dart:io';
import 'dart:math';
import 'dart:developer' as dp;
// import 'package:ai_chatbot/app/modules/routes/app_pages.dart';
// import 'package:flutter_gif/flutter_gif.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:get/get.dart';

// import '../modules/home/controllers/nav_view_ctl.dart';
// import '../modules/utills/Gems_rates.dart';

class Gems {
  // static const idGems10 = '10_gems';
  static const idGems100 = '100_gems';

  static const allids = [
    // idGems10,
    idGems100
  ];
}

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();

  factory RevenueCatService() {
    // Purchases.setEmail(email)
    return _instance;
  }

  RevenueCatService._internal();

  Rx<Entitlement> currentEntitlement = Entitlement.free.obs;

  final List<String> _productIds = [
    // Add your product identifiers here
    'premium_unlimited',
    // 'lifetime_premium',
  ];
  static var _apiKey = Platform.isAndroid
      ? 'goog_axQhifbtwvVFhykmmrLtGFLCJmc'
      : "appl_UyPHnxJaEzmIZtIfcHGeswULsQJ";

  Future<void> initialize(String customerID) async {
    print("Revenue Cat initialized called..");
    // String customerID="ranasherry94@gmail.com";
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(
            PurchasesConfiguration(_apiKey)..appUserID = customerID)
        .then((value) async {
      await checkSubscriptionStatus();
    });

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      updatePurchaseStatus();
    });
  }

//      Future<void> printCoinProducts() async {
//   final InAppPurchaseConnection _iapConnection = InAppPurchaseConnection.instance;

//   final ProductDetailsResponse response = await _iapConnection.queryProductDetails(
//     Set<String>.from(['coins_100', 'coins_250', 'coins_600', 'coins_1400']),
//   );

//   if (response.error != null) {
//     print("Error fetching products: ${response.error}");
//     return;
//   }

//   for (ProductDetails product in response.productDetails) {
//     print("Title: ${product.title}");
//     print("Description: ${product.description}");
//     print("Price: \$${product.price}");
//     print("-------");
//   }
// }

//   static Future<List<Package>> fetchOffersByIds(List<String> ids) async {
//   final offers = await fetchOffers();

//   // Create an empty list to hold the filtered packages
//   List<Package> filteredPackages = [];

//   // Iterate through the offerings and filter them based on identifiers
//   for (Offering offer in offers) {
//     if (ids.contains(offer.identifier)) {
//       // Assuming there's a way to convert an Offering into a Package
//       // You would need to provide the appropriate conversion logic
//       Package package = convertOfferingToPackage(offer);
//       filteredPackages.add(package);
//     }
//   }

//   // Return the filtered packages as a future
//   return Future.value(filteredPackages);
// }

//     static Future<List<Package>> fetchOffersByIds(List<String> ids) async {
//   final offers = await fetchOffers();

//   // Assuming `fetchOffers` returns a List<Package>
//   // You can filter and return only the packages with matching identifiers
//   return offers.where((offer) => ids.contains(offer.identifier)).toList();
// }

  //  Future<List<Package>> fetchOffersByIds( List<String>ids ) async {
  //   final offers = await fetchOffers();

  //   return offers.getPackage(identifier).where((offers)=> ids.contains(offer.identifier)).toList();
  // }

  //   Future<Offering?> fetchOffers() async{
  //   try {
  //     final offerings = await Purchases.getOfferings();

  //     // final current = offerings.current;
  //     return offerings.current;

  //     // return current = null ? <Offering>[] : <Offering>[current];
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // import 'package:purchases_flutter/purchases_flutter.dart';

  Future<List<Package>> getProducts() async {
    try {
      // Fetch available offerings
      final offerings = await Purchases.getOfferings();
      dp.log("Products offerings 1: $offerings");

      // Check if offerings are available
      if (offerings != null && offerings.all.isNotEmpty) {
        // Define the identifiers for the desired offerings
        final offer1Identifier = "100_gems";
        final offer2Identifier = "500_gems";

        // Retrieve the desired offerings from the map
        final offeringMap = offerings.all;
        final offer1 = offeringMap[offer1Identifier];
        dp.log("Offer1: $offer1");

        final offer2 = offeringMap[offer2Identifier];
        dp.log("Offer1: $offer2");

        // Check if the offerings are not null and have available packages
        if (offer1 != null && offer2 != null) {
          // Create a list to store the packages
          List<Package> packageList = [];

          // Add the first available package from offer1 to the list
          if (offer1.availablePackages.isNotEmpty) {
            packageList.add(offer1.availablePackages[0]);
          }

          // Add the first available package from offer2 to the list
          if (offer2.availablePackages.isNotEmpty) {
            packageList.add(offer2.availablePackages[0]);
          }

          // Log the packages or return them as needed
          dp.log("Products offerings: $packageList");
          return packageList;
        }
      }
    } catch (e) {
      // Handle any exceptions or errors that may occur during the process
      print("Error fetching products: $e");
    }

    // Return an empty list if no valid packages were found or an error occurred
    return [];
  }

  // Future<List<Package>> getProducts() async {
  //   // final products=await Purchases.getProducts(_productIds);

  //   final offerings = await Purchases.getOfferings();
  //   print("Offerings length: ${offerings.all.length}");

  //   // for (var offering in offerings.all.length) {}
  //   // printWrapped("Offerings : ${offerings.all.toString()}");

  //   // logger.d("Logger Offerings : ${offerings.all.toString()}");

  //   // for (var offering in offerings..all) {
  //   //   print("Offering : $offering");
  //   // }
  //  Map<String, Offering> offeringMap = offerings.all;
  // Offering? offer1=offeringMap["100_gems"];
  // Offering? offer2=offeringMap["500_gems"];
  //  List<Package> packageList=[];
  //  packageList.add(offer1!.availablePackages[0]);
  //  packageList.add(offer2!.availablePackages[0]);

  //   // dp.log("products offerings: ${offerings.all}");
  //   dp.log("products offerings: ${offer1}");
  //   // final packageList = offerings.current?.availablePackages ?? [];

  //   // getProducts2();
  //   return packageList;
  // }

  Future<List<StoreProduct>> getProducts2() async {
    final products = await Purchases.getProducts(_productIds);
    print("Products Length: ${products.length}");

    for (StoreProduct product in products) {
      print("My Product: $product");
    }
    return products;
  }

  void printWrapped(String text) =>
      RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);

  // Future<void> purchaseSubscription(Package package) async {
  //   try {
  //     NavCTL navCTL = Get.find();
  //     final purchaserInfo =
  //         await Purchases.purchasePackage(package).then((value) {
  //       if (package.storeProduct.description.contains("100")) {
  //         navCTL.increaseGEMS(GEMS_RATE.BUY_100_GEMS_RATE);
  //       }
  //       if (package.storeProduct.description.contains("500")) {
  //         navCTL.increaseGEMS(GEMS_RATE.BUY_500_GEMS_RATE);
  //       }
  //     });

  //     dp.log("Purchased ${purchaserInfo}");
  //     // Handle successful purchase
  //   } catch (error) {
  //     print("Purchase Error");
  //     // Handle purchase error
  //   }
  // }

  Future<void> purchaseSubscriptionWithProduct(StoreProduct product) async {
    try {
      final purchaserInfo = await Purchases.purchaseStoreProduct(product);

      // Handle successful purchase
    } catch (error) {
      // Handle purchase error
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      if (purchaserInfo.entitlements.active.isNotEmpty) {
        currentEntitlement.value = Entitlement.paid;
        // User is subscribed
        print('User is already subscribed');
      } else {
        currentEntitlement.value = Entitlement.free;
        // Get.toNamed(Routes.SUBSCRIPTION);
        currentEntitlement.value = Entitlement.free;
        // NavCTL navCTL = Get.find();
        // navCTL.subscriptionCall();
        // Get.toNamed(Routes.SUBSCRIPTION);

        // User is not subscribed
        print('User is not previously subscribed');
      }
    } catch (error) {
      // Error occurred while fetching the subscription status
      print('Error: $error');
    }
  }

  Future updatePurchaseStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      print("Purchase info: $purchaserInfo");
      if (purchaserInfo.entitlements.active.isNotEmpty) {
        currentEntitlement.value = Entitlement.paid;
        // User is subscribed
        print('User is subscribed');
      } else {
        currentEntitlement.value = Entitlement.free;

        // User is not subscribed
        print('User is not subscribed');
      }
    } catch (error) {
      // Error occurred while fetching the subscription status
      print('Error: $error');
    }
  }
}

enum Entitlement { free, paid }
