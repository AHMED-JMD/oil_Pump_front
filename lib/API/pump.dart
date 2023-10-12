import 'package:http/http.dart';
import 'dart:convert';

String apiUrl = 'http://localhost:5000/api/pump';


class API_Pump {

  static Future GetPump(data, token)async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/get');
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
  static Future GetAllPump(token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/');
      Response response = await get(url, headers: requestHeaders);

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return response.body;
      }
    }catch(e){
      print(e);
    }
  }
  //add pump
  static Future AddPump (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/add');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch(e){
      print(e);
    }
  }
  //delete pump
  static Future DeletePump (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/delete');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch(e){
      print(e);
    }
  }
  //update pump reading
  static Future UpdatePump (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/update');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch(e){
      print(e);
    }
  }
  //update pump
  static Future UpdatePumpData (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/update_pump');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch(e){
      print(e);
    }
  }
  //update price
  static Future Update_Price (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/update_price');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch(e){
      print(e);
    }
  }
}