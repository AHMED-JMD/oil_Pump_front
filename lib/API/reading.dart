import 'package:http/http.dart';
import 'dart:convert';

String apiUrl = 'http://localhost:5000/api/reading';


class API_Reading {
  //get reading
  static Future GetReading(data, token)async {
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
        return response.body;
      }
    }catch(e){
      print(e);
    }
  }
  //add reading
  static Future AddReading(data, token)async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/add');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
    }catch(e){
      print(e);
    }
  }
  //update reading
  static Future Update(data, token)async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/update');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
    }catch(e){
      print(e);
    }
  }
  //delete One reading
  static Future DeleteOne (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/delete_one');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e);
    }
  }
  //delete reading
  static Future Delete (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/delete');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e);
    }
  }

}