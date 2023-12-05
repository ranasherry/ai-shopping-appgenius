import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shopping_app/app/provider/admob_ads_provider.dart';
import 'package:shopping_app/app/utills/images.dart';
import '../../data/Gems_rates.dart';
import '../../utills/AppStrings.dart';
import '../../utills/CM.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';
import '../../utills/style.dart';
import '../controllers/gems_view_controller.dart';

class GemsView extends GetView<GemsViewController> {
  GemsView({Key? key}) : super(key: key);

  // // // Native Ad Implementation start // // //
  NativeAd? nativeAd;
  RxBool nativeAdIsLoaded = false.obs;

  initNative() {
    nativeAd = NativeAd(
      adUnitId: AppStrings.ADMOB_NATIVE,
      request: AdRequest(),
      // factoryId: ,
      nativeTemplateStyle:
          NativeTemplateStyle(templateType: TemplateType.medium),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');

          nativeAdIsLoaded.value = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  /// Native Ad Implemntation End ///

  @override
  Widget build(BuildContext context) {
    initNative();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: Text(
          'Get GEMS',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
            onTap: () {
              AdMobAdsProvider.instance.showInterstitialAd(() {});
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        // centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.03,
            ),
            Text(
              'Available GEMS',
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 6,
                  color: Colors.black),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.gems,
                  scale: 10,
                ),
                Obx(
                  () => Text(" ${controller.shoppingCTL.gems.value}",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 7,
                          color: Colors.black)),
                )
                // SizedBox(width: SizeConfig.screenWidth *0.03,)
              ],
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.03,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Watch Ads To Get GEMS:',
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.01,
                  ),
                  Ad_GEM_widget(),
                  //   Platform.isAndroid? Row(children: [
                  //     Text(
                  //           'Buy GEMS:',
                  //           style: StyleSheet.Intro_Sub_heading,
                  //         ),
                  //   ],):Container(),
                  //   SizedBox(height: SizeConfig.screenHeight *0.01,),
                  //  Platform.isAndroid? BUY_GEM_widget(context):Container()
                  AdMobAdsProvider.instance.isAdEnable.value
                      ? Center(
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 5),
                              child:
                                  NativeAdMethed(nativeAd, nativeAdIsLoaded)),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Ad_GEM_widget() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenHeight * 0.03,
        ),
        // ElevatedButton(onPressed: (){}, child: Text("Watch Interstitial AD (${GEMS_RATE.INTER_INCREAES_GEMS_RATE} GEMS)")),
        GestureDetector(
          onTap: () {
            AdMobAdsProvider.instance
                .showInterstitialAd(controller.increase_inter_gems);
          },
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.06,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.scaffold, // Set the border color here
                width: 2.0, // Set the border width here
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Center(
                child: Text(
              "Watch Interstitial AD (${GEMS_RATE.INTER_INCREAES_GEMS_RATE} GEMS)",
              style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
            )),
          ),
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.02,
        ),
        GestureDetector(
          onTap: () {
            AdMobAdsProvider.instance
                .ShowRewardedAd(controller.increase_reward_gems);
          },
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.06,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.scaffold, // Set the border color here
                width: 2.0, // Set the border width here
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Center(
                child: Text(
              "Watch Video AD (${GEMS_RATE.REWARD_INCREAES_GEMS_RATE} GEMS)",
              style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
            )),
          ),
        ),
        // ElevatedButton(onPressed: (){}, child: Text("Watch Video AD (${GEMS_RATE.REWARD_INCREAES_GEMS_RATE} GEMS)")),
        SizedBox(
          height: SizeConfig.screenHeight * 0.03,
        ),

        // Padding(
        //   padding:  EdgeInsets.all(10),
        //   child: Row(
        //     children: [
        //       Text(
        //                           'Buy GEMS',
        //                           style: StyleSheet.sub_heading12,
        //                         ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget BUY_GEM_widget(context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenHeight * 0.02,
        ),
        // ElevatedButton(onPressed: (){}, child: Text("Watch Interstitial AD (${GEMS_RATE.INTER_INCREAES_GEMS_RATE} GEMS)")),
        GestureDetector(
          onTap: () {
            //[j.] NavCTL navCTL = Get.find();
            // navCTL.subscriptionCall();
            // Get.toNamed(Routes.SUBSCRIPTION);
            _settingModalBottomSheet(context);
          },
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.06,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.icon_color, // Set the border color here
                width: 2.0, // Set the border width here
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            // child: Center(child: Text("Become Subscriber",style: StyleSheet.Intro_Sub_heading2,)),),
            child: Center(
                child: Text(
              "Buy GEMS",
              style: StyleSheet.Intro_Sub_heading2,
            )),
          ),
        ),
        //   SizedBox(height: SizeConfig.screenHeight *0.02,),
        // Container(
        //   width: SizeConfig.screenWidth *0.8,
        //   height: SizeConfig.screenHeight *0.06,
        //               decoration: BoxDecoration(
        //                 border: Border.all(
        //                   color: AppColors.icon_color, // Set the border color here
        //                   width: 2.0, // Set the border width here
        //                 ),
        //                 borderRadius: BorderRadius.circular(40.0),
        //               ),
        //   child: Center(child: Text("Watch Video AD (${GEMS_RATE.REWARD_INCREAES_GEMS_RATE} GEMS)",style: StyleSheet.Intro_Sub_heading2,)),),
        // // ElevatedButton(onPressed: (){}, child: Text("Watch Video AD (${GEMS_RATE.REWARD_INCREAES_GEMS_RATE} GEMS)")),
        // SizedBox(height: SizeConfig.screenHeight *0.03,),
        // Padding(
        //   padding:  EdgeInsets.all(10),
        //   child: Row(
        //     children: [
        //       Text(
        //                           'Buy GEMS',
        //                           style: StyleSheet.sub_heading12,
        //                         ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Row(
                  children: [],
                ),
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }
}
