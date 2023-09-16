import 'dart:convert';
import 'package:http/http.dart';

class API_Emp {
  static Future<dynamic> AddEmp (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/employee/');
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
  //update employee
  static Future<dynamic> UpdateEmp (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/employee/update_data');
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
  static Future<dynamic> EditEmp (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/employee/update');
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
  static Future<dynamic> getEmps ( token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/employee/');
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
  //get all clients
  static Future<dynamic> New_month ( token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/employee/new_month');
      Response response = await get(url, headers: requestHeaders);

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
    }catch (e) {
      print(e);
    }
  }
  //get one clients
  static Future<dynamic> getOneEmp (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/employee/get-one');
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
  static Future<dynamic> FindEmp (data, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/employee/find_one');
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
  static Future<dynamic> Delete_Emp (emp_id, token) async {
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('http://localhost:5000/employee/delete');
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