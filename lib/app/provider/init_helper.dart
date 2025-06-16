import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class InitializationHelper{
  Future<FormError?> initialize() async {
    print("UMP init");
    final completer = Completer<FormError?>(); 

    final params = ConsentRequestParameters(
      consentDebugSettings: ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea
      )
    );
    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      if(await ConsentInformation.instance.isConsentFormAvailable()){
        await _loadConsentForm();
      }
      else{
        await _initialize();
      }
      completer.complete();
     }, (error) {
      completer.complete(error);   
      });

      return completer.future;
  }

  Future<FormError?> _loadConsentForm() async {
    final completer = Completer<FormError?>();

    ConsentForm.loadConsentForm((consentForm) async {
      final status = await ConsentInformation.instance.getConsentStatus();
      if(status == ConsentStatus.required){
        consentForm.show((formError) {
          // _loadConsentForm();
          completer.complete(_loadConsentForm());
        });
      }
      else{
        await _initialize();
        completer.complete();
      }
     }, (formError) {
      completer.complete(formError);
     });
     return completer.future;
  }

  Future<void> _initialize() async{
    await MobileAds.instance.initialize();
  }
}