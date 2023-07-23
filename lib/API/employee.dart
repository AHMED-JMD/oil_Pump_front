import 'dart:convert';
import 'package:http/http.dart';

class API_Emp {
  static Future<dynamic> AddEmp (data, token) async {
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
  //delete clients
  static Future<dynamic> Delete_Emp (emp_id, token) async {
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