import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/app/data/authType.dart';
import 'package:shopping_app/app/routes/app_pages.dart';
import 'package:shopping_app/app/services/firebaseFunctions.dart';


// import 'package:flutterapp/services/functions/firebaseFunctions.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirestoreServices.saveUser(name, email, userCredential.user!.uid);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

//   static saveGoogleUserData(name,email) async {
//   // Get the current user from Firebase Auth
//   User? user = FirebaseAuth.instance.currentUser;

//   // Create a reference to the users collection
//   CollectionReference users = FirebaseFirestore.instance.collection('GoogleUsers');

//   // Create a map of data to store
//   Map<String, dynamic> userData = {
//     'name': name,
//     'email': email
//   };

//   // Add the data to the collection with the user's uid as the document id
//   await users.doc(user!.uid).set(userData);

//   // Print a confirmation message
//   print('User data saved successfully');
//   log("done");
// }

 static saveGoogleUserData(name,email) async {
  // Get the current user from Firebase Auth
  User? user = FirebaseAuth.instance.currentUser;

  // Create a reference to the users collection
  CollectionReference users = FirebaseFirestore.instance.collection('GoogleUsers');

  // Create a map of data to store
  Map<String, dynamic> userData = {
    'name': name,
    'email': email
  };

  // Check if the user data already exists in the collection
  DocumentSnapshot snapshot = await users.doc(user!.uid).get();

  // If the user data does not exist, add the data to the collection with the user's uid as the document id
  if (!snapshot.exists) {
    await users.doc(user.uid).set(userData);

    // Print a confirmation message
    print('User data saved successfully');
  } else {
    // Print a message that the user data already exists
    print('User data already exists');
  }
}



  static signinUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You are Logged in')));
          // final SharedPreferences prefs = await SharedPreferences.getInstance();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('method', AuthMethodType.email.toString() );
          Get.offAllNamed(Routes.SplashScreen);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password did not match')));
      }
    }
  }
}
