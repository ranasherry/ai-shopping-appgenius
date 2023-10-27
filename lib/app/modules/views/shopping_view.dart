import 'dart:developer';

import 'package:applovin_max/applovin_max.dart';
import 'package:clipboard/clipboard.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:im_animations/im_animations.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopping_app/app/modules/controllers/applovin_ads_provider.dart';
import 'package:shopping_app/app/utills/images.dart';
import '../../data/response_state.dart';
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
                  controller
                      .openURL("https://sites.google.com/view/appgeniusx/home");
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
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Obx(() => controller.responseState.value == ResponseState.idle
            ? GestureDetector(
                onTap: () {
                  controller.scaffoldKey.currentState!.openDrawer();
                },
                child: Icon(Icons.menu))
            : GestureDetector(
                onTap: () {
                  // controller.responseState.value = ResponseState.idle;
                  controller.onBackPressed();
                },
                child: Icon(Icons.arrow_back_ios_new))),
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
                    Text(" ${controller.gems.value}"),
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
            //[j.] Obx(() {
            //   if (RevenueCatService().currentEntitlement.value ==
            //           Entitlement.paid ||
            //       !AppLovinProvider.instance.isInitialized.value) {
            //     return Container(); // Return an empty container for paid users
            //   } else {
            //     return AppLovinProvider.instance.showMacBanner.value
            //         ? Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: MaxAdView(
            //               adUnitId: Platform.isAndroid
            //                   ? AppStrings.MAX_BANNER_ID
            //                   : AppStrings.IOS_MAX_BANNER_ID,
            //               adFormat: AdFormat.banner,
            //               listener: AdViewAdListener(
            //                 onAdLoadedCallback: (ad) {
            //                   print('Banner widget ad loaded from ' +
            //                       ad.networkName);
            //                 },
            //                 onAdLoadFailedCallback: (adUnitId, error) {
            //                   print(
            //                       'Banner widget ad failed to load with error code ' +
            //                           error.code.toString() +
            //                           ' and message: ' +
            //                           error.message);
            //                 },
            //                 onAdClickedCallback: (ad) {
            //                   print('Banner widget ad clicked');
            //                 },
            //                 onAdExpandedCallback: (ad) {
            //                   print('Banner widget ad expanded');
            //                 },
            //                 onAdCollapsedCallback: (ad) {
            //                   print('Banner widget ad collapsed');
            //                 },
            //               ),
            //             ),
            //           )
            //         : Container();
            //   }
            // [j.]}),
            Container(
              // height: 60,
              // color: Colors.amber,
              child: Center(
                child: MaxAdView(
                    adUnitId: AppStrings.MAX_BANNER_ID,
                    adFormat: AdFormat.banner,
                    listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                      print('Banner widget ad loaded from ' + ad.networkName);
                    }, onAdLoadFailedCallback: (adUnitId, error) {
                      print('Banner widget ad failed to load with error code ' +
                          error.code.toString() +
                          ' and message: ' +
                          error.message);
                    }, onAdClickedCallback: (ad) {
                      print('Banner widget ad clicked');
                    }, onAdExpandedCallback: (ad) {
                      print('Banner widget ad expanded');
                    }, onAdCollapsedCallback: (ad) {
                      print('Banner widget ad collapsed');
                    })),
              ),
            ),

            Obx(() => controller.responseState.value == ResponseState.idle
                ? _beforeResponseWidget(context)
                : _ProdcutResponseView()),
          ],
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
          child: TextField(
            controller: controller.productTextCTL,
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
          child: TextField(
            controller: controller.reviewsLimitCTL,
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
                        "${controller.country.value}",
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
            controller.callBardOrGPT(context);
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
