import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:oil_pump_system/models/Login.dart';

class SharedServices {
  //check logged in status
  static Future<bool> isLoggedIn () async{
    var isKeyExist = await APICacheManager().isAPICacheKeyExist('loginDetails');
    return isKeyExist;
  }

  //set login details
  static Future SetLoginDetails(Login model) async{
    APICacheDBModel CachedDb = APICacheDBModel(
        key: 'loginDetails',
        syncData: jsonEncode(model.toJson())
    );
    await APICacheManager().addCacheData(CachedDb);
  }

  //logout user
  static Future<void> logout (BuildContext context) async {
    await APICacheManager().deleteCache('loginDetails');

    Navigator.pushReplacementNamed(context, '/login');
  }
}