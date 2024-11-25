import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/security_scheme.dart';
import '../../utils/shared_preferences_helper.dart';

// The Auth codes which handle the login and signup calls to the online database.

class SBAuth {
  final AuthSB = Supabase.instance.client;
  // final hasher = PasswordHasher();
  final crypt = PasswordHandler();

  // Sign-up Function to Supabase table "user_credentials"
  Future<void> signUp(String user, String email, String password) async {
    try {
      //To encode password by using XOR Cipher
      final encryptedPassword = crypt.encode(password);

      //Parameters to insert into table "user_credentials". NB: Using XOR cipher to encrypt
      // so that the password can decoded and compared later in the Login Function.
      final response = await AuthSB.from('user_credentials').insert({
        'user': user,
        'email': email,
        'password': encryptedPassword,
      });

      await SharedPreferencesHelper.saveUsername(user);
      await SharedPreferencesHelper.saveUserEmail(email);

      if (response.error != null) {
        throw response.error!;
      }

      print("User signed up successfully");
    } catch (e) {
      print("Sign-up Error: $e");
      // Optionally, return an error message for the UI
    }
  }

  //Login Function to the Supabase table "user_credentials"
  Future<String> login(String email, String password) async {
    try {
      //To retrieve the parameters needed for authentication
      // from the table.
      final resp = await AuthSB.from('user_credentials')
          .select('password, user')
          .eq('email', email)
          .single();

      final encryptedPassword = resp['password'];
      debugPrint('entered password: $password');
      final decodedStoredPassword = crypt.decode(encryptedPassword);

      final storeUser = resp['user'];

      //Condition to compare the passwords to test authentication.
      if (password != decodedStoredPassword) {
        return "Login failed: Incorrect Credentials";
      }

      // Save login session to shared preferences
      await SharedPreferencesHelper.saveUserEmail(email);

      await SharedPreferencesHelper.saveUsername(storeUser); // Use the helper
      return "Login successful";
    } catch (e) {
      print("Login Error: $e");
      return "Sorry No Connection";
    }
  }

  // Method to check if a user is logged in
  Future<void> logout() async {
    // Clear login session using the helper
    await SharedPreferencesHelper.clearUserSession();
    print('user logged out');
  }

  Future<bool> isLoggedIn() async {
    return await SharedPreferencesHelper.isUserLoggedIn(); // Use the helper
  }

  Future<String?> getLoggedInUserName() async {
    return await SharedPreferencesHelper.getUsername(); // Use the helper
  }

  Future<String?> getLoggedInUserEmail() async {
    return await SharedPreferencesHelper.getUserEmail(); // Use the helper
  }

  // //Can edit
  // Future<String?> getLoggedInUserKey() async {
  //   return await SharedPreferencesHelper.getKeys(); // Use the helper
  // }
}
