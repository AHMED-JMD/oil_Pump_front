import 'package:http/http.dart';
import 'dart:convert';

String apiUrl = 'http://localhost:5000/api/gas';


class API_Gas {
  //get all gas
  static Future Get_All_Gas (token) async{
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
        return false;
      }
    }catch (e){
      print(e);
    }
  }
  //find gas
  static Future Find_Gas (data, token) async{
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/find');
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
  //delete gas
  static Future Delete_Gas (data, token) async{
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