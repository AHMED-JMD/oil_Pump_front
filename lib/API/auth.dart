import 'package:http/http.dart';
import 'dart:convert';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/models/Login.dart';

String apiUrl = 'http://localhost:5000/api/admin';

class API_auth {
  static Future Login(data) async{
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
      };

      final url = Uri.parse('$apiUrl/login');
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

      final url = Uri.parse('$apiUrl/register_new_admin');
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
        'x-auth-token' : '....token_goes_here..'
      };

      final url = Uri.parse('$apiUrl/register_new_admin');
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