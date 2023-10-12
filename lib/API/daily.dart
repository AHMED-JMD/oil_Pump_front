import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:5000/api/daily';


class API_Daily {
  //add new daily
  static Future Add_Daily (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch (e){
      print(e);
    }
  }

  //get daily
  static Future Get_Daily (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/view');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return response.body;
      }

    }catch (e){
      print(e);
    }
  }
  //get All daily
  static Future Get_All_Daily (token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/');
      Response response = await get(url, headers: requestHeaders,);

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return response.body;
      }

    }catch (e){
      print(e);
    }
  }
  //get One daily
  static Future Get_One_Daily (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/viewOne');
      Response response = await post(url, headers: requestHeaders,body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }

    }catch (e){
      print(e);
    }
  }

  //get One daily
  static Future Delete_Daily (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/delete');
      Response response = await post(url, headers: requestHeaders,body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }

    }catch (e){
      print(e);
    }
  }

}