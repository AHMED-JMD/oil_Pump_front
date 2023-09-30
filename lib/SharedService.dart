import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:OilEnergy_System/models/Login.dart';

class SharedServices {
  //check logged in status
  static Future<bool> isLoggedIn () async{
    var isKeyExist = await APICacheManager().isAPICacheKeyExist('loginDetails');
    return isKeyExist;
  }

  //get login details
  static Future<Login> LoginDetails() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist('loginDetails');

    if(isKeyExist){
      var cachedData = await APICacheManager().getCacheData('loginDetails');

      return loginResponseJson(cachedData.syncData);
    }else{
      return loginResponseJson('');
    }
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

  //----------------get the date of the dailys------------
  static Future SetDate(DateTime? date) async{
    APICacheDBModel CachedDb = APICacheDBModel(
        key: 'date',
        syncData: (date!.toIso8601String())
    );
    await APICacheManager().addCacheData(CachedDb);
  }

  //get date
  static Future GetDate() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist('date');

    if(isKeyExist){
      var cachedData = await APICacheManager().getCacheData('date');

      return cachedData.syncData;
    }else{
      return loginResponseJson('');
    }
  }
}