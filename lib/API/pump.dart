import 'package:http/http.dart';
import 'dart:convert';


class API_Pump {

  static Future GetPump(name)async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMyNGQ2ZTMwLTE5NzAtMTFlZS05MTczLWZiMjA5ZjI2YWQyMyIsImlhdCI6MTY4ODM2ODMxNH0.FuZln5gldCx3LWd_ylaxHDyiwt0oSId_98MvrKfCvOA'
      };

      final url = Uri.parse('http://localhost:5000/pump/get');
      Map data = {};
      data['name'] = name;
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
        return data;
      }else{
        return response.body;
      }
    }catch(e){
      print(e);
    }
  }

  //get all pumps
  static Future GetAllPump() async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMyNGQ2ZTMwLTE5NzAtMTFlZS05MTczLWZiMjA5ZjI2YWQyMyIsImlhdCI6MTY4ODM2ODMxNH0.FuZln5gldCx3LWd_ylaxHDyiwt0oSId_98MvrKfCvOA'
      };

      final url = Uri.parse('http://localhost:5000/pump/');
      Response response = await get(url, headers: requestHeaders);

      if(response.statusCode == 200){
        List data = jsonDecode(response.body);
        return data;
      }else{
        return response.body;
      }
    }catch(e){
      print(e);
    }
  }
}