import 'dart:convert';
import 'package:http/http.dart';

class API_Daily {
  static Future Add_Daily (data) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMyNGQ2ZTMwLTE5NzAtMTFlZS05MTczLWZiMjA5ZjI2YWQyMyIsImlhdCI6MTY4ODM2ODMxNH0.FuZln5gldCx3LWd_ylaxHDyiwt0oSId_98MvrKfCvOA'
      };

      final url = Uri.parse('http://localhost:5000/transaction/');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
  }catch (e){
      print(e);
    }
}

//delete daily from server
  static Future Delete_Daily (data) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMyNGQ2ZTMwLTE5NzAtMTFlZS05MTczLWZiMjA5ZjI2YWQyMyIsImlhdCI6MTY4ODM2ODMxNH0.FuZln5gldCx3LWd_ylaxHDyiwt0oSId_98MvrKfCvOA'
      };

      final url = Uri.parse('http://localhost:5000/transaction/delete');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
    }catch (e){
      print(e);
    }
  }
}