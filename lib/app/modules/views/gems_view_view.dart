import 'dart:io';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/app/utills/images.dart';
import '../../data/Gems_rates.dart';
import '../../utills/AppStrings.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';
import '../../utills/style.dart';
import '../controllers/applovin_ads_provider.dart';
import '../controllers/gems_view_controller.dart';

class GemsView extends GetView<GemsViewController> {
  const GemsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Get GEMS'),
        leading: GestureDetector(
            onTap: () {
              AppLovinProvider.instance.showInterstitial(() {});
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new)),
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
            AppLovinProvider.instance
                .showInterstitial(controller.increase_inter_gems);
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
            AppLovinProvider.instance
                .showRewardedAd(controller.increase_reward_gems);
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
        Container(
          // height: 60,
          // color: Colors.amber,
          child: Center(
            child: MaxAdView(
                adUnitId: AppStrings.MAX_MREC_ID,
                adFormat: AdFormat.mrec,
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
