import 'dart:convert';
import 'dart:developer';
import 'package:applovin_max/applovin_max.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/Gems_rates.dart';
import '../../data/response_state.dart';
import '../../routes/app_pages.dart';
import '../../utills/AppStrings.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';
import '../../utills/style.dart';
import 'applovin_ads_provider.dart';

class ShoppingController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement ShoppingController
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxInt current_index = 0.obs;
  int initialGems = 20;
  RxInt gems = 0.obs;
  bool? firstTime = false;

  // RxInt gems = 0.obs;
  //  int gems_rate = 3;
  // [j.]NavCTL navCTL = Get.find();

  bool callBard = AppStrings.ACTIVE_BARD;

  RxString JsonFromRealTimeApi = "".obs;

  RxString productName = "".obs;
  RxString rating = "".obs;
  RxDouble reviewsLimit = 0.0.obs;
  RxString selectStore = "".obs;
  // RxString priceQuality= "".obs;
  RxString country = "United States".obs;
  RxDouble userRating = 3.0.obs;
  IconData? selectedIcon;
  bool isVertical = false;
  RxString countryCodeNumber = "".obs;
  List<String> store = [
    'Amazon',
    'eBay',
    'Ali Express',
    'Over All',
    'Top Shop'
  ];
  // RxBool isCheckedStore = false.obs;
  RxBool isCheckedAmazon = false.obs;
  RxBool isCheckedeBay = false.obs;
  RxBool isCheckedAli = false.obs;
  RxBool isCheckedBest = false.obs;
  RxBool isCheckedAll = true.obs;
  TextEditingController productTextCTL = TextEditingController(text: "AirPods");
  TextEditingController reviewsLimitCTL = TextEditingController(text: "200");
  //  List<bool> checkedList = [];
  // RxList<bool> isChecked = [false, false, false, false, false].obs;
  RxString? selectedStore = 'Amazon'.obs;
  List<String> priceQuality = [
    'BEST MATCH',
    'TOP RATED',
    'LOWEST PRICE',
    'HIGHEST PRICE'
  ];
  // List<String> priceQuality = [
  //   'Best Price',
  //   'Best Quality',
  //   'Cheap Price',
  //   'Mid Range '
  // ];
  // RxString? selectedpriceQuality = 'Best Price'.obs;
  RxString? selectedpriceQuality = 'BEST MATCH'.obs;
  final count = 0.obs;

  String responseData = "";
  RxString output = "".obs;

  RxString title = "Product Deatils".obs;

  String requestTemplate = "";

  Rx<ResponseState> responseState = ResponseState.idle.obs;
  late OpenAI openAi;

  final APIKEY = AppStrings.GOOGLE_SHOPPING_APIKEY;
  RxBool? isFirstTime = true.obs;
  final prefs = SharedPreferences.getInstance();

  // ""

  // String requestTemplate =
  // "You are writing an article to help users make an informed decision about the best products available on an online store. Based on the search results from the Custom Search API, you will compare the top 3 products according to their prices, reviews, ratings, and quality.Here is the top 3 products json response I found from the online store:JSON Response Here______In this article, you will provide a detailed comparison of these products, considering their prices, customer reviews, ratings, and overall quality. Your goal is to assist users in making an informed decision about which product best suits their needs.Please write the article, covering the following points:1. Briefly introduce the importance of product research and informed decision-making for online shoppers.2. Analyze each product's price and compare them, considering affordability and value for money.3. Evaluate customer reviews and ratings for each product to gauge user satisfaction.4. Discuss the overall quality of each product, considering features, materials, and durability.5. Provide your recommendation on the best product among the three, and explain the reasons behind your choice.Feel free to add any additional insights or comparisons that you find relevant to help readers make an informed decision.";
  @override
  void onInit() {
    // searchAndSaveProductData("Iphone","886ff05605mshbebba3b2ff469aap1fb826jsn0b627542f3e9");
    openAi = OpenAI.instance.build(
      token: AppStrings.OPENAI_TOKEN,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
    );
    if (kDebugMode) {
      initialGems = 100;
    } else {
      initialGems = GEMS_RATE.FREE_GEMS;
    }

    AppLovinProvider.instance.init();

    CheckUser().then((value) {
      getGems();
    });

///// AppOpen Implementation
    if (AppLovinProvider.instance.isInitialized.value) {
      AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(
        onAdLoadedCallback: (ad) {},
        onAdLoadFailedCallback: (adUnitId, error) {},
        onAdDisplayedCallback: (ad) {},
        onAdDisplayFailedCallback: (ad, error) {
          AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
        },
        onAdClickedCallback: (ad) {},
        onAdHiddenCallback: (ad) {
          AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
        },
        onAdRevenuePaidCallback: (ad) {},
      ));

      AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
    }

    WidgetsBinding.instance.addObserver(this);

    super.onInit();
    prefs.then((SharedPreferences pref) {
      isFirstTime?.value = pref.getBool('first_time') ?? true;

      print("Is First Time from Init: $isFirstTime");
    });
    // checkedList = List.generate(store.length, (index) => false);
    // getlimit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("AppState  : ${state}");
    switch (state) {
      case AppLifecycleState.resumed:
        await showAdIfReady();
        print("App Resume :");
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> showAdIfReady() async {
    if (!AppLovinProvider.instance.isInitialized.value) {
      return;
    }

    bool isReady =
        (await AppLovinMAX.isAppOpenAdReady(AppStrings.MAX_APPOPEN_ID))!;
    if (isReady) {
      AppLovinMAX.showAppOpenAd(AppStrings.MAX_APPOPEN_ID);
    } else {
      AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
    }
  }

  // Future getlimit() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   gems.value = prefs.getInt('gems')!;
  // }

  //  savelimit() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   await prefs.setInt('gems', gems.value);
  // }

  callBardOrGPT(context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      if (callBard == true) {
        valid(context);
      } else {
        // log("no");
        if (productName.isNotEmpty) {
          if (isCheckedAmazon.value == true) {
            log("amazone store called");
            searchAndSaveHighRatedProductsToJsonWithStore(
                productName.value, APIKEY);
          } else {
            searchAndSaveHighRatedProductsToJson(productName.value, APIKEY);
          }
        } else {
          Toster("Product name Please!", AppColors.Green_color);
        }
      }
    } else {
      Toster("No Internet", AppColors.Green_color);
    }
  }

  ShareApp() {
    Share.share(
        "Consider downloading this exceptional app, available on the Google Play Store at the following link: https://play.google.com/store/apps/details?id=com.appgenius.shoppingexpert.ai");
  }

  // Toster(msg,color){
  //   Fluttertoast.showToast(
  //       msg: "$msg",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: color,
  //       textColor: AppColors.white_color,
  //       fontSize: 16.0
  //   );
  // }

  valid(context) async {
    if (gems.value > 0 && gems.value >= GEMS_RATE.Shopping_GEMS_RATE) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        // sendMessage(formattedJson);
        //  makeThePrompt(context);
        EasyLoading.show(status: "Please Wait");
        String sites = "";
        if (isCheckedAmazon.value) {
          sites += " Amazon";
        }
        if (isCheckedeBay.value) {
          sites += " Ebay";
        }
        if (isCheckedAli.value) {
          sites += " Ali Express";
        }
        if (isCheckedBest.value) {
          sites += " Best Buy";
        }
        if (sites == "") {
          sites += "Top Sites";
        }

        fetchReponce(sites).then((value) async {
          List<String> links = extractLinks(responseData);
          await _bardImplemetation(sites, links.toString());
          // validator(context);
        });

        // fetchReponce().then((value) {
        //   validator(context);
        // });
        print("Internet ON");
      } else {
        Toster("No internet Connection", AppColors.Lime_Green_color);
        print("Internet OFF");
      }
    } else {
      // GemsFinished();
      Toster("No More Gems Available", AppColors.Electric_Blue_color);
      Get.toNamed(Routes.GemsView);
    }
  }

  void showNetworkErrorDialog() {
    Get.defaultDialog(
      title: "Network Error",
      middleText: "Please try again later.",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      onConfirm: () {
        Get.back(); // Close the dialog box
      },
    );
  }

  Future<void> _bardImplemetation(String sites, String googleSearch) async {
    print("Extracted Links: $googleSearch");
    String BardReq =
        "Compare the product: (${productName.value}) available in following links and give the link of best product available  Links=$googleSearch write paragraph in atleast 100 words include link in your response as well. Do not mention that you are given the links of product just write as you know everything. and give your response in bullet points. do not give your response in latext format";
    // String BardReq =
    //     "Compare the best ${productName.value} in sites: $sites and country: ${country.value} with more then ${userRating.value} reviews. Write short paragraph on comparison and give available link of best product among all. Note: link should not be expired";
    // String BardReq =
    //     "Copamare top 3 the product: ${productName.value} from sites: $sites with reviews > ${userRating.value} and country=${country.value}. write a short paragraph on their comparison and give atleast a single link at the end for the best product. make headings if you want to. and conclude everything in 100 words Note: 1- do not show data in tabular form.  3- link must exist and in working currently";
    // String BardReq =
    //     "q=give me reviews about the product ${productName.value} and also give some details of site: Amazon:${isCheckedAmazon.value},eBay:${isCheckedeBay.value},Ali Express:${isCheckedAli.value},best buy:${isCheckedBest.value}, reviews > ${userRating.value} country=${country.value}&lang=en&num=3  Extra Request: Write everything in Proper format and compare top products available in 150 words and give link about the best product at the end. do not put brackets or any other character around link as I am using linkify to show tho whole output Example linkes:  www.google.com  ,  www.youtube.com";

    try {
      String generatedText = await generateTextBardAPI(
          prompt: BardReq, apiKey: AppStrings.PALM_APIKEY);
      // Do something with the generated text, like updating the UI.

      output.value = generatedText;
      responseState.value = ResponseState.success;
      EasyLoading.dismiss();
      decreaseGEMS(GEMS_RATE.Shopping_GEMS_RATE);

      print("OutPut Value: ${output.value}");
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error occured Try again later");
      showNetworkErrorDialog();
      // Handle the exception here, e.g., show an error message.
      print('Error generating text: $e');
      // You can also update the UI to display an error message.

      output.value = 'Error generating text: $e';
    }
  }

  Toster(msg, color) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: AppColors.white_color,
        fontSize: 16.0);
  }

  validator(context) async {
    // if (productName.value.isEmpty || reviewsLimit.value.isEmpty) {
    if (productName.value.isEmpty) {
      print("Empty song");
      alert(context);
    } else {
      List<String> links = extractLinks(requestTemplate);
      print("message: ${links}");

      sendMessage(responseData);
      // navCTL.gems.value = navCTL.gems.value - GEMS_RATE.Shopping_GEMS_RATE;
      // // savelimit();
      // navCTL.saveGems(navCTL.gems.value);
      // navCTL.decreaseGEMS(GEMS_RATE.Shopping_GEMS_RATE);
      // Get.toNamed(Routes.CHAT_VIEW_V_I_P, arguments: [
      //             requestTemplate,
      //             title
      //           ]);
    }
  }

  alert(context) {
    AwesomeDialog(
      context: context,
      dialogBackgroundColor: AppColors.white_color,
      animType: AnimType.SCALE,
      dialogType: DialogType.NO_HEADER,
      title: 'Please Check your Internet Connection!',
      titleTextStyle: TextStyle(color: AppColors.black_color, fontSize: 20),
      descTextStyle: TextStyle(color: AppColors.black_color, fontSize: 14),
      desc:
          'The Offline Mode Alert is a feature that notifies users of no internet connection. It helps maintain a smooth user experience by displaying a clear message and providing suggestions for reconnecting.',
      // btnOkIcon: Icons.launch,
      body: Container(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.screenWidth * 0.04),
            // padding: const EdgeInsets.all(8.0),
            child: Text("Empty Fields!", style: StyleSheet.view_heading),
          ),
          // SizedBox(height: SizeConfig.screenHeight *0.02,),
          Padding(
            padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
            child: Text("Please ensure that you have filled all the details",
                style: StyleSheet.sub_heading2),
          ),
          // SizedBox(height: SizeConfig.screenHeight *0.02,),
        ],
      )),
      btnOkColor: AppColors.buttonColor,
      btnCancelColor: AppColors.brightbuttonColor,
      btnOkText: "OK",
      btnOkOnPress: () {
        // final service = FlutterBackgroundService();
        // AllowStepToCount(service);
      },
      // btnCancelOnPress: () {
      //   // onEndIconPress(context);
      // }
    )..show();
  }

  List<String> extractLinks(String text) {
    List<String> links = [];
    RegExp linkRegExp = RegExp(
        r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
    Iterable<RegExpMatch> matches = linkRegExp.allMatches(text);

    for (RegExpMatch match in matches) {
      String url = match.group(0)!;

      // Check if the URL is from the Google Play Store
      if (!url.contains("play.google.com") &&
          !url.contains("play") &&
          !url.contains("encrypted")) {
        // Check if the URL ends with common image extensions or PDF extensions
        if (!url.endsWith(".jpg") &&
            !url.endsWith(".jpeg") &&
            !url.endsWith(".png") &&
            !url.endsWith(".gif") &&
            !url.endsWith(".pdf")) {
          links.add(url);
        }
      }
    }

    return links;
  }

  Future fetchReponce(String sites) async {
    EasyLoading.show(status: "Please Wait");
    String shoppingReq =
        "https://www.googleapis.com/customsearch/v1?key=${AppStrings.SHOPPING_KEY}&cx=${AppStrings.SHOPPING_CX}&q=give me links of ${productName.value} available in ${country.value} with reviews > ${userRating.value}  &num=3";

    // String shoppingReq =
    //     "https://www.googleapis.com/customsearch/v1?key=${AppStrings.SHOPPING_KEY}&cx=${AppStrings.SHOPPING_CX}&q=give me reviews about the product ${productName.value} and also give some details of site: Amazon:${isCheckedAmazon.value},eBay:${isCheckedeBay.value},Ali Express:${isCheckedAli.value},best buy:${isCheckedBest.value}, reviews > ${userRating.value} country=${country.value}&lang=en&num=3";

    final url = Uri.parse(shoppingReq);

    print("Shopping Request: $shoppingReq");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON data
        final decodedData = json.decode(response.body);

        // responseData = json.encode(decodedData); // Convert the JSON data back to a string for display
        // print("responce: ${responseData}");
        // Check if the response has 'items' key and it is a list (assuming it is a list of items)
        if (decodedData.containsKey('items') && decodedData['items'] is List) {
          // List<dynamic> itemsList = decodedData['items']["link"];
          List<dynamic> itemsList = decodedData['items'];

// Iterate through the itemsList to extract the "link" values
          List<String> links = [];

          for (var item in itemsList) {
            if (item.containsKey("link")) {
              links.add(item["link"]);
            }
          }
          // Now, you have the 'items' list to work with
          // You can convert it back to a JSON string for display or iterate through the items
          // String itemsJsonString = json.encode(links);
          // print("items: $itemsJsonString");
          // String items=itemsJsonString

          // log("Product Response: $itemsJsonString");
          // responseData = itemsJsonString;
          responseData = links.toString();

          //  requestTemplate = "JSON Response Here '${itemsJsonString}'provide a comparison of these products, considering their prices, customer reviews, ratings, and overall quality.Also menstion product's prices,reviews,ratings, and overall quality.Please cover the following points:1. Analyze each product's price and compare them, considering affordability and value for money.2. Evaluate customer reviews and ratings for each product to gauge user satisfaction.3. Discuss the overall quality of each product, considering features, materials, and durability.4. Provide your recommendation on the best product among the three, and explain the reasons behind your choice and also provide the best product link. try to make the reponse under 150 words";
        } else {
          EasyLoading.showError("Sorry Product could not found");
          // If the 'items' key is not found or it is not a list, handle the error
          print("Error: 'items' not found in the response or it is not a list");
        }
      } else {
        EasyLoading.showError("Sorry Product could not found");

        // If the server did not return a 200 OK response, handle the error
        // setState(() {
        responseData = "Request failed with status: ${response.statusCode}";
        // });
      }
    } catch (error) {
      EasyLoading.showError("Sorry Product could not found");

      // Handle any other errors that occurred during the request
      // setState(() {
      responseData = "Error: $error";
      // });
    }
  }

  Future sendMessage(String json) async {
    log("inside sendMessage");
// String message="try to give response using under ${AppStrings.MAX_MATHPIXTOKEN} Tokens.  Solve all Math Problem in below Text if exist. Also explain and write math notation into LaTeX notation also use latex notation if it occur in explanation sentence. Text:  $text";
    //  String System = "Summarise the Video on the basis of caption data provided by user message. if there are no caption available then show apology message in proper way. User should not know that you are generating summaray using subtitle or caption. ${AppStrings.AppNameIntrucPrompt}";
    requestTemplate =
        // "JSON Response in User Message provide a comparison of these products, considering their prices, customer reviews, ratings, and overall quality.Also mention product's prices,reviews,ratings, and overall quality.Please cover the following points:1. Analyze each product's price and compare them, considering affordability and value for money.2. Evaluate customer reviews and ratings for each product to gauge user satisfaction.3. Discuss the overall quality of each product, considering features, materials, and durability.4. Provide your recommendation on the best product among the three, and explain the reasons behind your choice and also always provide the best product link if there is not any best then just provide any link available in json. try to make the reponse under 150 words and make sure not to include word like json or anything like that which make the user to think about that we are getting data from json or any other api";
        "Compare the product available in following links and give the link of best product available  Links, write paragraph in atleast 100 words include link in your response as well. Do not mention that you are given the links of product just write as you know everything. and give your response in bullet points";

    String System = requestTemplate;
    print("Solve the Math Problem if Exisit in following  $responseData");

    final systemMessage = Messages(role: Role.system, content: System);
    final userMessage = Messages(role: Role.user, content: json);
    final request = ChatCompleteText(
      messages: [systemMessage, userMessage],
      // maxToken: AppStrings.MAX_CHAT_TOKKENS,
      maxToken: AppStrings.MAX_MATHPIXTOKEN,
      model: GptTurbo0301ChatModel(),
    );

    try {
      final response = await openAi.onChatCompletion(request: request);

      for (var element in response!.choices) {
        print("data -> ${element.message?.content}");
        print("dataID -> ${element.id}");
        // isWaitingForResponse.value = false;
        // shimmerEffect.value = false;
      }
      EasyLoading.dismiss();

      print("ConversationalID: ${response.conversionId}");
      print("ConversationalID: ${response.id}");

      if (response.choices.isNotEmpty &&
          response.choices.first.message != null) {
        // responseState.value=ResponseState.success;
        // conversationID = response.choices.first.message!.id;
      } else {
        responseState.value = ResponseState.failure;
        EasyLoading.dismiss();
        EasyLoading.showError("Could not Found Product data");
      }

      ChatMessage messageReceived = ChatMessage(
          senderType: SenderType.Bot,
          message: response.choices[0].message!.content,
          input: json);
      // EasyLoading.dismiss();
      //
      String originalString = messageReceived.message;
      output.value = originalString;
      responseState.value = ResponseState.success;

      log("data should be printed");
      // print("OutPut Value: ${output.value}");
      log("OutPut Value: ${output.value}");

      // String removeString = limit;
      // messageReceived.input = originalString.replaceFirst(removeString, '');
      //
      // chatList.insert(0, messageReceived);

      // request_limit.value--;
      // navCTL.gems.value = navCTL.gems.value - GEMS_RATE.YT_GEMS_RATE;
      // // savelimit();
      // navCTL.saveGems(navCTL.gems.value);
      decreaseGEMS(GEMS_RATE.Shopping_GEMS_RATE);
      setFirstTime(true);
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      EasyLoading.showError("Could not summarize video..");
      // EasyLoading.dismiss();
      // EasyLoading.showError("Something Went Wrong");
      if (err is OpenAIAuthError) {
        print('OpenAIAuthError error ${err.data?.error?.toMap()}');
      }
      if (err is OpenAIRateLimitError) {
        print('OpenAIRateLimitError error ${err.data?.error?.toMap()}');
      }
      if (err is OpenAIServerError) {
        print('OpenAIServerError error ${err.data?.error?.toMap()}');
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<int> getGems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      gems.value = prefs.getInt('gems') ?? 100;
    } else {
      gems.value = prefs.getInt('gems') ?? GEMS_RATE.FREE_GEMS;
    }
    print("GEMS value: ${gems.value}");
    return gems.value;
  }

  decreaseGEMS(int decrease) async {
    print("value: $decrease");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gems.value = gems.value - decrease;
    if (gems.value < 0) {
      gems.value = 0;
      await prefs.setInt('gems', gems.value);
    } else {
      await prefs.setInt('gems', gems.value);
    }

    print("inters");
    getGems();
  }

  increaseGEMS(int increase) async {
    print("value: $increase");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gems.value = gems.value + increase;
    await prefs.setInt('gems', gems.value);
    print("inters");
    getGems();
  }

  Future CheckUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool('first_time');

    // var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime!) {
      // Not first time
      gems.value = prefs.getInt('gems')!;
      print("Not First time");
      print("${firstTime}");
      //     Timer(Duration(seconds: 3), () {
      //       // CheckUser();
      //       // AppLovinProvider.instance.init();
      //       Get.offNamed(Routes.NAV,arguments: false);
      // });
    } else {
      // First time
      prefs.setBool('first_time', false);
      print("First time");
      print("${firstTime}");
      await prefs.setInt('limit', 5);
      await prefs.setInt('mathLimit', 3);
      await prefs.setInt('gems', initialGems).then((value) {
        gems.value = prefs.getInt('gems')!;
      });
    }
  }

  void onBackPressed() async {
    responseState.value = ResponseState.idle;
    productTextCTL.clear();
    reviewsLimitCTL.clear();
    userRating.value = userRating.value;
    isCheckedAmazon = false.obs;
    isCheckedeBay = false.obs;
    isCheckedAli = false.obs;
    isCheckedBest = false.obs;
    isCheckedAll = false.obs;
    selectedpriceQuality?.value = "BEST MATCH";
    country.value = "Select Country";
    countryCodeNumber;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setFirstTime(bool bool) {
    print("setFirstTime");
    prefs.then((SharedPreferences pref) {
      pref.setBool('first_time', bool);

      print("Is First Time: $isFirstTime");
    });
  }

  void increment() => count.value++;

  Future openURL(String ur) async {
    final Uri _url = Uri.parse(ur);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<String> generateTextBardAPI(
      {required String prompt, required String apiKey}) async {
    //? Temprature
    // 0.0	Very factual and coherent text
    // 0.1	Somewhat factual and coherent text, with some creative elements
    // 0.2	Creative and unpredictable text, but still mostly coherent
    // 0.3	Very creative and unpredictable text
    // 0.4	Completely random text
    final String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=$apiKey';

    final Map<String, dynamic> requestBody = {
      "prompt": {
        "text": prompt,
      },
      "temperature": 0.1,
      // "top_k": 40,
      // "top_p": 0.95,
      "candidate_count": 1,
      "max_output_tokens": 500,
      "stop_sequences": [],
      "safety_settings": [
        {"category": "HARM_CATEGORY_DEROGATORY", "threshold": 1},
        {"category": "HARM_CATEGORY_TOXICITY", "threshold": 1},
        {"category": "HARM_CATEGORY_VIOLENCE", "threshold": 2},
        {"category": "HARM_CATEGORY_SEXUAL", "threshold": 2},
        {"category": "HARM_CATEGORY_MEDICAL", "threshold": 2},
        {"category": "HARM_CATEGORY_DANGEROUS", "threshold": 2},
      ]
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody));

    print("Response Code From Bard: ${response.statusCode}");
    print("Response From Bard: ${response..body.toString()}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // print("Response From Bard: ${response..body.toString()}");
      log("Response Data From Bard: $data");

      final String generatedText = data["candidates"][0]["output"] as String;
      return generatedText;
    } else {
      throw Exception('Failed to generate text: ${response.reasonPhrase}');
    }
  }

  // final apiKey = '886ff05605mshbebba3b2ff469aap1fb826jsn0b627542f3e9';
  // final query = 'Nike shoes';

  void noProductsFound() {
    Get.dialog(
      AlertDialog(
        title: Text('No Product found'),
        content: Text('Try to reduce your Rating or Review Limit '),
        actions: [
          // ElevatedButton.icon(
          //   onPressed: () {
          //     // TODO: Implement the action for watching an ad
          //     // AppLovinProvider.instance.showRewardedAd(onRewardWatched);
          //     Get.back(); // Close the dialog
          //   },
          //   icon: Icon(Icons.play_arrow),
          //   label: Text('Watch Ad for 5 More Chats'),
          // ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<String> searchAndSaveHighRatedProductsToJson(
      String query, String apiKey) async {
    // Easy
    EasyLoading.show(status: "Please Wait");
    final String apiUrl =
        'https://real-time-product-search.p.rapidapi.com/search';

    final Map<String, dynamic> queryParams = {
      'q': query,
      'country': '$countryCodeNumber', // You can change this as needed
      // 'country': 'us', // You can change this as needed
      // Add other optional parameters here
      // isCheckedAll.value?
      // 'sort_by' : '$selectedpriceQuality',
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'real-time-product-search.p.rapidapi.com',
    };

    try {
      final response = await http.get(uri, headers: headers);
      log("Response: $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        log("data in if: $data");

        // // Extract the product data you want from the response
        // final product = data['data'][0]; // Assuming you want the first product
        // final title = product['product_title'];
        // final description = product['product_description'];
        // final rating = product['product_rating'];
        // final offerPageUrl = product['product_offers_page_url'];
        // final price = product['offer']['price'];

        // // Create a ProductData object to store the data
        // final productData = ProductData(
        //   title: title,
        //   description: description,
        //   rating: rating.toDouble(),
        //   offerPageUrl: offerPageUrl,
        //   price: price,
        // );

        // Extract product details and store them in a list
        final List<ProductData> productList = [];

        for (final product in data['data']) {
          // log("data in if: $data");
          final title = product['product_title'];
          final description = product['product_description'];
          final rating = product['product_rating'];
          final reviewCount = product['product_num_reviews'];
          final offerPageUrl = product['product_offers_page_url'];
          final price = product['offer']['price'];

          // final productData = ProductData(
          //   title: title,
          //   description: description,
          //   rating: rating.toDouble(),
          //   offerPageUrl: offerPageUrl,
          //   price: price,
          // );
          // if (rating >= 4.5) {
          // if (reviewCount >= 500) {
          if (reviewCount >= reviewsLimit.value) {
            if (rating >= userRating.value) {
              final productData = ProductData(
                title: title,
                description: description,
                rating: rating.toDouble(),
                reviewCount: reviewCount.toDouble(),
                offerPageUrl: offerPageUrl,
                price: price,
              );
              // log("Data: ${productData.title}");
              log("Data: ${productData.title}");
              log("Data: ${productData.description}");
              log("Data: ${productData.rating}");
              log("Data: ${productData.reviewCount}");
              log("Data: ${productData.offerPageUrl}");
              log("Data: ${productData.price}");
              log("Data: ${productList}");

              productList.add(productData);
            }
          }

          // log("Data: ${productData.title}");
          // productList.add(productData);

          if (productList.length > 10) {
            break;
          }
        }

        log("number of products: ${productList.length}");
        // Convert the list of ProductData objects to JSON
        final List<Map<String, dynamic>> productListMap =
            productList.map((product) => product.toMap()).toList();

        final String productListJson = jsonEncode(productListMap);

        log("Data: ${productListJson}");

        JsonFromRealTimeApi.value = productListJson;

        log("data from the api");

        if (productList.length <= 0) {
          // Toster("No Product found", AppColors.background_color);

          EasyLoading.dismiss();
          noProductsFound();
        } else {
          sendMessage(productListJson);
        }

        // return data;

        // Return the ProductData object
        // return productList;

        // Return the JSON string
        return productListJson;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  String AmazonID = "g113872638";

  Future<String> searchAndSaveHighRatedProductsToJsonWithStore(
      String query, String apiKey) async {
    // Easy
    EasyLoading.show(status: "Please Wait");
    final String apiUrl =
        'https://real-time-product-search.p.rapidapi.com/search';

    final Map<String, dynamic> queryParams = {
      'q': query,
      'country': '$countryCodeNumber', // You can change this as needed
      // 'country': 'us', // You can change this as needed
      // Add other optional parameters here
      // isCheckedAll.value?
      'store_id': '$AmazonID',
      // 'sort_by' : '$selectedpriceQuality',
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'real-time-product-search.p.rapidapi.com',
    };

    try {
      final response = await http.get(uri, headers: headers);
      log("Response: $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        log("data in if: $data");

        // // Extract the product data you want from the response
        // final product = data['data'][0]; // Assuming you want the first product
        // final title = product['product_title'];
        // final description = product['product_description'];
        // final rating = product['product_rating'];
        // final offerPageUrl = product['product_offers_page_url'];
        // final price = product['offer']['price'];

        // // Create a ProductData object to store the data
        // final productData = ProductData(
        //   title: title,
        //   description: description,
        //   rating: rating.toDouble(),
        //   offerPageUrl: offerPageUrl,
        //   price: price,
        // );

        // Extract product details and store them in a list
        final List<ProductData> productList = [];

        for (final product in data['data']) {
          // log("data in if: $data");
          final title = product['product_title'];
          final description = product['product_description'];
          final rating = product['product_rating'];
          final reviewCount = product['product_num_reviews'];
          // final offerPageUrl = product['product_offers_page_url'];
          final offerPageUrl = product['offer']['offer_page_url'];
          final price = product['offer']['price'];

          // final productData = ProductData(
          //   title: title,
          //   description: description,
          //   rating: rating.toDouble(),
          //   offerPageUrl: offerPageUrl,
          //   price: price,
          // );
          // if (rating >= 4.5) {
          // if (reviewCount >= 500) {
          if (reviewCount >= reviewsLimit.value) {
            if (rating >= userRating.value) {
              final productData = ProductData(
                title: title,
                description: description,
                rating: rating.toDouble(),
                reviewCount: reviewCount.toDouble(),
                offerPageUrl: offerPageUrl,
                price: price,
              );
              // log("Data: ${productData.title}");
              log("Data: ${productData.title}");
              log("Data: ${productData.description}");
              log("Data: ${productData.rating}");
              log("Data: ${productData.reviewCount}");
              log("Data: ${productData.offerPageUrl}");
              log("Data: ${productData.price}");
              log("Data: ${productList}");

              productList.add(productData);
            }
          }

          // log("Data: ${productData.title}");
          // productList.add(productData);

          if (productList.length > 10) {
            break;
          }
        }

        log("number of products: ${productList.length}");
        // Convert the list of ProductData objects to JSON
        final List<Map<String, dynamic>> productListMap =
            productList.map((product) => product.toMap()).toList();

        final String productListJson = jsonEncode(productListMap);

        log("Data: ${productListJson}");

        JsonFromRealTimeApi.value = productListJson;

        log("data from the api");

        if (productList.length <= 0) {
          // Toster("No Product found", AppColors.background_color);

          EasyLoading.dismiss();
          noProductsFound();
        } else {
          sendMessage(productListJson);
        }

        // return data;

        // Return the ProductData object
        // return productList;

        // Return the JSON string
        return productListJson;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class ProductData {
  final String title;
  final String description;
  final double rating;
  final double reviewCount;
  final String offerPageUrl;
  final String price;

  ProductData({
    required this.title,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.offerPageUrl,
    required this.price,
  });

  // Convert ProductData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'offerPageUrl': offerPageUrl,
      'price': price,
    };
  }
}

enum SenderType {
  User,
  Bot,
}

class ChatMessage {
  SenderType senderType;
  String message;
  String input;

  ChatMessage(
      {required this.senderType, required this.message, required this.input});
}
