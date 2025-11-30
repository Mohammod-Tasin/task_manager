import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../DATA/Models/user_model.dart';

class AuthController {

  static final String _accessTokenKey = 'token';
  static final String _userModelKey = 'user';

  static String? accessToken;
  static UserModel? userModel;

  static Future<void> saveUserData(UserModel model, String token) async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(_accessTokenKey, token);
      await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
      // todo : user model ke save korar jonno shared preference e rakhte hobe
      // todo : shared preference e string akare rakhar jonno model ke string e convert korte hobe.
      // todo : ejonno userModel class e json e convert kora holo, then ekhane jsonEncode kora holo, bcz
      // todo : jsonEncode korle raw string hoe jay
      accessToken = token;
      userModel = model;
  }

  static Future<void>getUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    if(token !=null){
      String? userData = sharedPreferences.getString(_userModelKey);
      userModel = UserModel.fromJson(jsonDecode(userData!));
      accessToken = token;
    }
  }

  static Future<bool> isUserAlreadyLoggedin() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    return token!=null;
  }

  static Future<void> clearUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static Future<void> updateUserData(UserModel model) async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
      // todo : user model ke save korar jonno shared preference e rakhte hobe
      // todo : shared preference e string akare rakhar jonno model ke string e convert korte hobe.
      // todo : ejonno userModel class e json e convert kora holo, then ekhane jsonEncode kora holo, bcz
      // todo : jsonEncode korle raw string hoe jay
      userModel = model;
  }

}