import 'dart:developer';
import 'package:clipboard/clipboard.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:im_animations/im_animations.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shimmer/shimmer.dart';

import 'package:shopping_app/app/utills/images.dart';
import '../../data/response_state.dart';
import '../../provider/admob_ads_provider.dart';
import '../../routes/app_pages.dart';
import '../../utills/AppStrings.dart';
import '../../utills/Gems_rates.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';
import '../../utills/style.dart';
import '../controllers/shopping_controller.dart';
// import 'package:markdown/markdown.dart' as md;

class ShoppingView extends GetView<ShoppingController> {
  ShoppingView({Key? key}) : super(key: key);

  // // // Banner Ad Implementation start // // //
// ? Commented by jamal start
  // late BannerAd myBanner;
  // RxBool isBannerLoaded = false.obs;

  // initBanner() {
  //   BannerAdListener listener = BannerAdListener(
  //     // Called when an ad is successfully received.
  //     onAdLoaded: (Ad ad) {
  //       print('Ad loaded.');
  //       isBannerLoaded.value = true;
  //     },
  //     // Called when an ad request failed.
  //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //       // Dispose the ad here to free resources.
  //       ad.dispose();
  //       print('Ad failed to load: $error');
  //     },
  //     // Called when an ad opens an overlay that covers the screen.
  //     onAdOpened: (Ad ad) {
  //       print('Ad opened.');
  //     },
  //     // Called when an ad removes an overlay that covers the screen.
  //     onAdClosed: (Ad ad) {
  //       print('Ad closed.');
  //     },
  //     // Called when an impression occurs on the ad.
  //     onAdImpression: (Ad ad) {
  //       print('Ad impression.');
  //     },
  //   );

  //   myBanner = BannerAd(
  //     adUnitId: AppStrings.ADMOB_BANNER,
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: listener,
  //   );
  //   myBanner.load();
  // } // ? Commented by jamal end

  /// Banner Ad Implementation End ///

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // initBanner(); // ? Commented by jamal
    return Form(
      key: controller.formKey,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        key: controller.scaffoldKey,
        drawer: Drawer(
          width: SizeConfig.blockSizeHorizontal * 75,
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 30,
                color: AppColors.drawer,
                child: Image.asset(
                  AppImages.drawer,
                  scale: 5,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    LaunchReview.launch(
                      androidAppId: "com.appgenius.shoppingexpert.ai",
                    );
                  },
                  child: drawer_widget(Icons.thumb_up, "Rate Us")),
              GestureDetector(
                  onTap: () {
                    controller.ShareApp();
                  },
                  child: drawer_widget(Icons.share, "Share")),
              GestureDetector(
                  onTap: () {
                    controller.openURL(
                        "https://sites.google.com/view/appgeniusx/home");
                  },
                  child: drawer_widget(Icons.privacy_tip, "Privacy Policy"))
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Text(
            'Shopping',
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
          leading:
              Obx(() => controller.responseState.value == ResponseState.idle
                  ? GestureDetector(
                      onTap: () {
                        controller.scaffoldKey.currentState!.openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ))
                  : GestureDetector(
                      onTap: () {
                        // controller.responseState.value = ResponseState.idle;
                        controller.onBackPressed();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ))),
          actions: [
            Obx(() =>
                // RevenueCatService().currentEntitlement.value == Entitlement.paid?
                //     Container()
                //     :
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.GemsView);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.gems,
                        scale: 30,
                      ),
                      Text(
                        " ${controller.gems.value}",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.03,
                      )
                    ],
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: SizeConfig.blockSizeVertical * 8,
                    width: SizeConfig.blockSizeHorizontal * 85,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFF5D4A7), Color(0xFFFCEDD9)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      // color: Color(0xFFD5E4FF),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 4),
                          bottomRight: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300, // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 10, // Blur radius
                          offset: Offset(0, 5), // Offset in x and y direction
                        ),
                      ],
                    ),
                    child: Center(
                        child: Text(
                      "Note: This Content is AI generated",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xFF013961)
                          color: Color(0xFF976133)),
                    )),
                  ),
                ],
              ),
              // ? Commented by jamal start
              // Obx(() => isBannerLoaded.value &&
              //         AdMobAdsProvider.instance.isAdEnable.value
              //     ? Container(
              //         height: AdSize.banner.height.toDouble(),
              //         child: AdWidget(ad: myBanner))
              //     : Container()),// ? Commented by jamal end
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Obx(() => controller.responseState.value == ResponseState.idle
                  ? _beforeResponseWidget(context)
                  : _ProdcutResponseView()),
            ],
          ),
        ),
      ),
    );
  }

  Shimmer ShimmerLoader() {
    return Shimmer.fromColors(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            preview_effect(SizeConfig.blockSizeHorizontal * 65),
            preview_effect(SizeConfig.blockSizeHorizontal * 65),
            preview_effect(SizeConfig.blockSizeHorizontal * 65),
            preview_effect(SizeConfig.blockSizeHorizontal * 65),
            preview_effect(SizeConfig.blockSizeHorizontal * 30),
          ],
        ),
        baseColor: Colors.grey.shade600,
        highlightColor: Colors.white);
  }

  Container preview_effect(double width) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 0.5,
          bottom: SizeConfig.blockSizeVertical * 0.5),
      height: SizeConfig.blockSizeVertical * 1,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 3)),
    );
  }

  Column _beforeResponseWidget(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Text(
        //   'ShoppingView is working',
        //   style: TextStyle(fontSize: 20),
        // ),
        SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300, // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, 5), // Offset in x and y direction
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.productTextCTL,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },

            cursorColor: Colors.black,
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4,
                color: Colors.black),
            decoration: InputDecoration(
              // hintText: text,

              // "Product Name",

              prefixIcon: Icon(
                Icons.shopping_cart,
                color: AppColors.scaffold,
              ),
              labelText: "Product Name",
              labelStyle: TextStyle(color: Colors.grey.shade500),

              hintText: "Example: Nike Shoes",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
                  borderSide: BorderSide.none
                  // borderSide: BorderSide(
                  //   color: Color(0xFF0095B0), // Border color
                  //   width: 1.0, // Border width
                  // ),
                  ),

              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
                borderSide: BorderSide(
                  color: AppColors.scaffold,
                  // Color(0xFF0095B0), // Border color when focused
                  width: 1.0, // Border width when focused
                ),
              ),
            ),

            // cursorColor: Colors.white,
            //               style: TextStyle(
            //                   // fontSize: SizeConfig.blockSizeHorizontal * 4,
            //                   color: Colors.white),
            // decoration: InputDecoration(labelText:
            // "Product Name",
            // // fillColor: Colors.white
            // // colo
            // ),
            onChanged: (value) {
              print(value);
              controller.productName.value = value;
            },
          ),
        ),

        SizedBox(height: 16.0),
        // SizedBox(height: 16.0),
        // SizedBox(height: 16.0),
        Container(
          // width: SizeConfig.screenWidth *0.5,
          // height: SizeConfig.screenWidth *0.2,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300, // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, 5), // Offset in x and y direction
              ),
            ],
            // border: Border.all(
            //   color: AppColors.icon_color, // Set the border color here
            //   width: 2.0, // Set the border width here
            // ),
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
            // color: AppColors.Electric_Blue_color,
            // borderRadius: BorderRadius.circular(12.0), // Adjust the radius as per your preference
          ),
          padding: EdgeInsets.all(16.0),
          child: RatingBar.builder(
            unratedColor: Colors.grey.shade300,
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20,
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              controller.userRating.value = rating;
            },
          ),
        ),
        SizedBox(height: 16.0),
        // SizedBox(height: 16.0),
        Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300, // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, 5), // Offset in x and y direction
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.reviewsLimitCTL,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            cursorColor: Colors.black,
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4,
                color: Colors.black),
            decoration: InputDecoration(
              // hintText: text,
              // "Product Name",
              prefixIcon: Icon(
                Icons.star_rate,
                color: AppColors.scaffold,
              ),
              fillColor: Colors.white,
              filled: true,
              labelStyle: TextStyle(color: Colors.grey.shade500),
              labelText: "Reviews More Then",
              hintText: "Example: 200",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
                  borderSide: BorderSide.none
                  // borderSide: BorderSide(
                  //   color: Color(0xFF0095B0), // Border color
                  //   width: 1.0, // Border width
                  // ),
                  ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
                borderSide: BorderSide(
                  color: AppColors.scaffold, // Border color when focused
                  width: 1.0, // Border width when focused
                ),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]')), // Only allow digits
              LengthLimitingTextInputFormatter(3), // Limit to 3 characters
            ],
            // cursorColor: AppColors.icon_color,
            //               style: TextStyle(
            //                   // fontSize: SizeConfig.blockSizeHorizontal * 4,
            //                   color: Colors.white),
            // decoration: InputDecoration(labelText:
            // "Reviews Limit"
            // ),
            onChanged: (value) {
              print(value);
              // controller.reviewsLimit.value = value;
              controller.reviewsLimit.value = double.parse(value);
            },
          ),
        ),

        SizedBox(height: 16.0),
        SizedBox(height: 16.0),
        // SizedBox(height: 16.0),
        Obx(
          () => Container(
            // color: AppColors.Bright_Pink_color,
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300, // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 10, // Blur radius
                            offset: Offset(0, 5), // Offset in x and y direction
                          ),
                        ],
                        // border: Border.all(
                        //   color:
                        //       AppColors.icon_color, // Set the border color here
                        //   width: 2.0, // Set the border width here
                        // ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: Color(0xFFFF9054),
                              value: controller.isCheckedAmazon.value,
                              onChanged: (bool? newValue) {
                                // This function will be called when the check box state changes
                                // newValue contains the new state of the check box (true or false)
                                controller.isCheckedAmazon.value =
                                    newValue ?? false; // Ensure it is not null

                                if (controller.isCheckedAmazon.value == true) {
                                  controller.isCheckedeBay.value = false;
                                  controller.isCheckedAli.value = false;
                                  controller.isCheckedAll.value = false;
                                }
                              },
                            ),
                            Text("Amazon",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300, // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 10, // Blur radius
                            offset: Offset(0, 5), // Offset in x and y direction
                          ),
                        ],
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: Color(0xFFFF9054),
                              value: controller.isCheckedeBay.value,
                              onChanged: (bool? newValue) {
                                // This function will be called when the check box state changes
                                // newValue contains the new state of the check box (true or false)
                                controller.isCheckedeBay.value =
                                    newValue ?? false; // Ensure it is not null

                                if (controller.isCheckedeBay.value == true) {
                                  controller.isCheckedAmazon.value = false;
                                  controller.isCheckedAli.value = false;
                                  controller.isCheckedAll.value = false;
                                }
                              },
                            ),
                            Text("eBay",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300, // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 10, // Blur radius
                            offset: Offset(0, 5), // Offset in x and y direction
                          ),
                        ],
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: Color(0xFFFF9054),
                              value: controller.isCheckedAli.value,
                              onChanged: (bool? newValue) {
                                // This function will be called when the check box state changes
                                // newValue contains the new state of the check box (true or false)
                                controller.isCheckedAli.value =
                                    newValue ?? false; // Ensure it is not null

                                if (controller.isCheckedAli.value == true) {
                                  controller.isCheckedAmazon.value = false;
                                  controller.isCheckedeBay.value = false;
                                  controller.isCheckedAll.value = false;
                                }
                              },
                            ),
                            Text("Ali Express",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300, // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 10, // Blur radius
                            offset: Offset(0, 5), // Offset in x and y direction
                          ),
                        ],
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,

                              activeColor: Color(0xFFFF9054),
                              // checkColor: Color(0xFFBC4301),
                              // fillColor: Color(0xFFFF9054),
                              value: controller.isCheckedAll.value,
                              onChanged: (bool? newValue) {
                                // This function will be called when the check box state changes
                                // newValue contains the new state of the check box (true or false)
                                controller.isCheckedAll.value =
                                    newValue ?? false; // Ensure it is not null

                                if (controller.isCheckedAll.value == true) {
                                  controller.isCheckedAmazon.value = false;
                                  controller.isCheckedeBay.value = false;
                                  controller.isCheckedAli.value = false;
                                }
                              },
                            ),
                            Text("Over All",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Container(
          //   width: SizeConfig.screenWidth *0.4,
          //   decoration: BoxDecoration(
          //       color: AppColors.Electric_Blue_color,
          //       borderRadius: BorderRadius.circular(12.0), // Adjust the radius as per your preference
          //     ),
          //   child: Center(
          //     child:
          //     DropdownButton<String>(
          //       value: controller.selectedStore?.value,
          //       items: controller.store.map((item) =>DropdownMenuItem<String>(
          //         value: item,
          //         child: Text(item,style: StyleSheet.sub_heading12,)
          //         )).toList(),
          //       onChanged: (item){
          //         controller.selectedStore?.value = item!;
          //       }
          //       ),
          //   ),
          // )
        ),
        SizedBox(height: 24.0),
        // SizedBox(height: 16.0),
        // SizedBox(height: 16.0),
        Obx(() => Container(
              width: SizeConfig.screenWidth * 0.4,
              decoration: BoxDecoration(
                // color: AppColors.Electric_Blue_color,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300, // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 10, // Blur radius
                    offset: Offset(0, 5), // Offset in x and y direction
                  ),
                ],
                // border: Border.all(
                //   color: AppColors.icon_color, // Set the border color here
                //   width: 1.0, // Set the border width here
                // ),
                borderRadius: BorderRadius.circular(
                    12.0), // Adjust the radius as per your preference
              ),
              child: Center(
                child: DropdownButton<String>(
                    dropdownColor: AppColors.drawer,
                    value: controller.selectedpriceQuality?.value,
                    items: controller.priceQuality
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                              ),
                            )))
                        .toList(),
                    onChanged: (item) {
                      controller.selectedpriceQuality?.value = item!;
                    }),
              ),
            )),
        SizedBox(height: 16.0),
        // SizedBox(height: 16.0),
        // SizedBox(height: 16.0),
        GestureDetector(
          onTap: () {
            showCountryPicker(
                context: context,
                // searchAutofocus: true,
                useSafeArea: true,
                showPhoneCode:
                    false, // optional. Shows phone code before the country name.
                onSelect: (Country country) {
                  print('Select country: ${country.displayName}');
                  controller.country.value = country.displayNameNoCountryCode;
                  controller.countryCodeNumber.value = country.countryCode;
                  log(country.countryCode);
                },
                countryListTheme: CountryListThemeData(
                  backgroundColor: AppColors.white_color,
                  // textStyle: StyleSheet.Intro_Sub_heading
                ));
          },
          child: Container(
            width: SizeConfig.screenWidth * 0.4,
            height: SizeConfig.screenWidth * 0.15,
            decoration: BoxDecoration(
              // color: AppColors.Electric_Blue_color,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300, // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 10, // Blur radius
                  offset: Offset(0, 5), // Offset in x and y direction
                ),
              ],
              // border: Border.all(
              //   color: AppColors.icon_color, // Set the border color here
              //   width: 1.0, // Set the border width here
              // ),
              borderRadius: BorderRadius.circular(
                  12.0), // Adjust the radius as per your preference
            ),
            child: Center(
                child: Obx(() => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        controller.isFirstTime!.value
                            ? "${controller.country.value}"
                            : "United States",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 3.5),
                      ),
                    ))),
          ),
        ),
        SizedBox(height: 16.0),
        SizedBox(height: 16.0),
        SizedBox(height: 16.0),

        GestureDetector(
          onTap: () {
            if (controller.formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              // // ScaffoldMessenger.of(context).showSnackBar(
              // //   const SnackBar(content: Text('Processing Data')),
              // );

              controller.callBardOrGPT(context);
              // controller.sendGemeniMessage("userInput");
            }
          },
          child: HeartBeat(
            child: Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1),
              height: SizeConfig.blockSizeVertical * 7,
              width: SizeConfig.blockSizeHorizontal * 65,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Color(0xFFFF9054), Color(0xFFBC4301)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.isFirstTime!.value
                                ? 'Get Result'
                                : 'Try It',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "(Uses  ",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  AppImages.gems,
                                  scale: 30,
                                ),
                                Text(
                                  " ${GEMS_RATE.Shopping_GEMS_RATE}",
                                  style: StyleSheet.Intro_Sub_heading2,
                                ),
                              ],
                            ),
                            Text(
                              " )",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Text("${controller.responseData}"),
      ],
    );
  }

  Column _ProdcutResponseView() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 2,
                vertical: SizeConfig.blockSizeVertical),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 2,
                  vertical: SizeConfig.blockSizeVertical),

              width: SizeConfig.blockSizeHorizontal * 92,
              //highlight
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.scaffold),
              ),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 1),
                          child: Icon(
                            Icons.chrome_reader_mode,
                            size: SizeConfig.blockSizeHorizontal * 6,
                            color: Colors.grey,
                          ),
                        ),
                        horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                        Text(
                          "Product Detail",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    // horizontalSpace(
                    //     SizeConfig.blockSizeHorizontal * 45),
                    GestureDetector(
                      onTap: () {
                        // controller.reshuffle(context);
                        controller.responseState.value = ResponseState.idle;
                      },
                      child: Icon(
                        Icons.repeat,
                        size: SizeConfig.blockSizeHorizontal * 7,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                // Container(
                //   height: 2000,
                //   child: Markdown(
                //     // controller: controller,
                //     selectable: true,
                //     data: '${controller.output.value}',
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                  child: Obx(() => controller.responseState.value !=
                          ResponseState.waiting
                      // controller.shimmerEffect.value
                      ? Container(
                          // height: 2000,
                          child:
                              //   Text(
                              //   "${controller.output.value}",
                              //   style: StyleSheet.Intro_Sub_heading,
                              // )
                              Markdown(
                            shrinkWrap: true,
                            // controller: controller,
                            physics: NeverScrollableScrollPhysics(),
                            selectable: true,
                            styleSheetTheme:
                                MarkdownStyleSheetBaseTheme.material,
                            // styleSheet: StyleSheet.darkMarkdownStyleSheet,
                            data: '${controller.output.value}',
                            onTapLink: (text, href, title) {
                              print("Link: $href");
                              controller.openURL(href ?? "");
                            },
                          ),
                        )
                      // Linkify(
                      //     onOpen: (link) {
                      //       controller.openURL(link.url);
                      //       print("Link to Open: $link");
                      //     },
                      //     text: "${controller.output.value}",
                      //     style: TextStyle(color: AppColors.black_color),
                      //   )
                      // TeXView(child: TeXViewColumn(children: [
                      //   // TeXViewDocument("5y^2+\frac{7}{5} + 5y^2-\frac{48}{5} - 2\sqrt{(5y^2+\frac{7}{5})(5y^2-\frac{48}{5})} = 1")
                      //   // TeXViewDocument(r"\[5y^2 + \frac{7}{5} + 5y^2 - \frac{48}{5} - 2\sqrt{(5y^2 + \frac{7}{5})(5y^2 - \frac{48}{5})} = 1\]")
                      //   TeXViewDocument("${controller.output.value}",
                      //   style: TeXViewStyle(
                      //     contentColor: Colors.white
                      //   )
                      //   )
                      // ]),loadingWidgetBuilder: (context) =>ShimmerLoader() ,)
                      // Text(
                      //     "${controller.output.value}",
                      //     style: TextStyle(
                      //         fontSize:
                      //             SizeConfig.blockSizeHorizontal *
                      //                 4,
                      //         color: Colors.white),
                      //   )
                      : ShimmerLoader()),
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     right: SizeConfig.blockSizeHorizontal * 2,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       // GestureDetector(
                //       //   onTap: () {
                //       //     // controller.copyText();
                //       //   },
                //       //   child: Icon(
                //       //     Icons.copy,
                //       //     size:
                //       //         SizeConfig.blockSizeHorizontal * 7,
                //       //     color: Colors.white,
                //       //   ),
                //       // ),
                //       // horizontalSpace(
                //       //     SizeConfig.blockSizeHorizontal * 4),
                //       // GestureDetector(
                //       //   onTap: () {
                //       //     // controller.shareText();
                //       //   },
                //       //   child: Icon(
                //       //     Icons.ios_share,
                //       //     size:
                //       //         SizeConfig.blockSizeHorizontal * 7,
                //       //     color: Colors.white,
                //       //   ),
                //       // ),
                //       horizontalSpace(
                //           SizeConfig.blockSizeHorizontal * 4),
                //       GestureDetector(
                //         onTap: () {
                //           // controller.reshuffle(context);
                //           controller.responseState.value=ResponseState.idle;
                //         },
                //         child: Icon(
                //           Icons.repeat,
                //           size:
                //               SizeConfig.blockSizeHorizontal * 7,
                //           color: Colors.white,
                //         ),
                //       )
                //     ],
                //   ),
                // )
                GestureDetector(
                  onTap: () {
                    // controller.reshuffle(context);
                    // controller.responseState.value=ResponseState.idle;
                    // FlutterClipboard.copy(controller.output.value).then(( value ) => print('copied'));
                    FlutterClipboard.copy(controller.output.value)
                        .then((value) {
                      controller.Toster("Copied!", AppColors.Green_color);
                    });
                  },
                  child: Container(
                    //         decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //    border: Border.all(color: AppColors.icon_color)
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.copy,
                          size: SizeConfig.blockSizeHorizontal * 7,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.02,
                        ),
                        Text(
                          "Copy",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 3.5),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            )),
        Container(
          padding: EdgeInsets.all(16.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Note: ',
                  style: TextStyle(
                    color: Colors.blue, // Change the color as needed
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                    text:
                        'We are continuously working to improve this feature. ',
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                  // text: 'Responses may not be 100% accurate. ',
                  text:
                      'These responses are generated by AI and may not always reflect 100% accuracy.',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                    text:
                        'You can always regenerate the response by clicking the regenerate button below.',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.responseState.value = ResponseState.idle;
            controller.productTextCTL.clear();
            controller.reviewsLimitCTL.clear();
            controller.isCheckedAll.value = false;
            controller.country.value = "Select Country";
          },
          child: Container(
            height: SizeConfig.blockSizeVertical * 6,
            width: SizeConfig.blockSizeHorizontal * 60,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400, // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 10, // Blur radius
                    offset: Offset(0, 5), // Offset in x and y direction
                  ),
                ],
                // color: AppColors.neonBorder,
                gradient: LinearGradient(
                    colors: [Color(0xFFFF9054), Color(0xFFBC4301)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                // Color(0xFF05284B),

                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8)),
            child: Center(
                child: Text(
              "Regenerate",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.white),
            )),
          ),
        )
        // ElevatedButton(
        //   onPressed: () {
        //     // Add your regenerate logic here
        //     controller.responseState.value = ResponseState.idle;
        //   },
        //   child: Text('Regenerate'),
        // )
      ],
    );
  }

  Padding drawer_widget(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 5,
          top: SizeConfig.blockSizeVertical * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: SizeConfig.blockSizeHorizontal * 7,
            color: AppColors.drawer,
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 12),
          Text(
            text,
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }
}
