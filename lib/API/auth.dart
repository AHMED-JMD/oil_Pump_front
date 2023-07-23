import 'package:http/http.dart';
import 'dart:convert';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/models/Login.dart';

class API_auth {
  static Future Login(data) async{
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
      };

      final url = Uri.parse('http://localhost:5000/admin/login');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      Map<String, dynamic> datas = jsonDecode(response.body);
      if(response.statusCode == 200){

        SharedServices.SetLoginDetails(loginResponseJson(response.body));
        return true;
      }else{
        return datas['msg'];
      }
    }catch (e){
      print(e);
    }
  }

  //Register new user
  static Future Register(data) async{
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
      };

      final url = Uri.parse('http://localhost:5000/admin/register_new_admin');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));
      if(response.statusCode == 200){
        return true;
      }else{
        return response;
      }
    }catch (e){
      print(e);
    }
  }

  //get user
  static Future GetUser(data) async{
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjJiMjRkYjQwLTIzMjItMTFlZS04ZmI5LTQ3MTZmY2E4MzZmNiIsImlhdCI6MTY4OTQzNDAzOX0.TS-sXOZEbsHGYrt6QqE-DXekMVrYN235McI2iZYu4Y0'
      };

      final url = Uri.parse('http://localhost:5000/admin/register_new_admin');
      Response response = await get(url, headers: requestHeaders);
      if(response.statusCode == 200){
        return true;
      }else{
        return response;
      }
    }catch (e){
      print(e);
    }
  }
}