// import 'package:ai_chatbot/app/providers/init_helper.dart';
// import 'package:flutter/material.dart';

// class Initializescreen extends StatefulWidget{
//   final tragetWidget;
//   const Initializescreen({required this.tragetWidget});

//   @override
//   State<Initializescreen> createState()=> _InitializescreenState();
// } 

// class _InitializescreenState extends State<Initializescreen>{

//   final _initializationHelper = InitializationHelper();

//   @override
//   void initState(){
//     super.initState();

//     _initialize();
//   }

//   @override
//   Widget build(BuildContext context) => const Scaffold(
//     body: Center(child: CircularProgressIndicator(),),
//   );
  
//   Future<void> _initialize() async{
//     final navigator = Navigator.of(context);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _initializationHelper.initialize();
//       navigator.pushReplacement(MaterialPageRoute(builder: (context) => widget.tragetWidget));
//      });
//   }
// }

//  import 'package:ai_chatbot/app/providers/init_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/app/provider/init_helper.dart';

class Initializescreen extends GetView<InitializationHelper> {
  final  tragetWidget;
  const Initializescreen({required this.tragetWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Future<void> onInit() async {
    // super.onInit();
    await controller.initialize();
    Future.delayed(Duration.zero, () {
      Get.off(() => tragetWidget);
    });
  }
}
