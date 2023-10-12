import 'package:http/http.dart';
import 'dart:convert';

String apiUrl = 'http://localhost:5000/api/reciept';


class API_Reciept {
  static Future Add_Reciept (data, token) async{
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
  static Future Update (data, token) async{
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
    }catch (e){
      print(e);
    }
  }

  //get one receipt by id
  static Future GetById (data, token) async{
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/get_one');
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
  //delete reciept
  static Future Delete_Reciept (data, token) async{
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

}