import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:5000/api/transaction';


class API_Trans {

  static Future Add_Trans (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/');
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

  //update client account
  static Future<dynamic> UpdateTrans (data, token) async {
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
    }catch (e) {
      print(e);
    }
  }

//delete transaction from server
  static Future Delete_Trans (data, token) async {
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
        return response.body;
      }
    }catch (e){
      print(e);
    }
  }

  //get one transaction from server
  static Future get_Trans (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/get-one');
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

  //get one transaction by Id
  static Future Get_byId (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/get_byId');
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

  //get client transaction from server
  static Future client_Trans (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/cli_trans');
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

  //get employees transaction from server
  static Future emp_Trans (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/emp_trans');
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

}