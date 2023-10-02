import 'dart:convert';
import 'package:http/http.dart';

class API_Client {
  static Future<dynamic> AddClient (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/clients/');
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
  //update client account
  static Future<dynamic> UpdateCLient (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/clients/update_info');
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
  //edit client account
  static Future<dynamic> EditClient (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/clients/update');
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
  //get all clients
  static Future<dynamic> getClients ( token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/clients/');
      Response response = await get(url, headers: requestHeaders);

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch (e) {
      print(e);
    }
  }
  //get one clients
  static Future<dynamic> getOneClients (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/clients/get-one');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch (e) {
      print(e);
    }
  }
  //find client
  static Future<dynamic> FindClient (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/clients/find_one');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch (e) {
      print(e);
    }
  }
  //delete clients
  static Future<dynamic> Delete_Client (emp_id, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/clients/delete');
      Response response = await post(url, headers: requestHeaders, body: jsonEncode(emp_id));

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
    }catch (e) {
      print(e);
    }
  }
}