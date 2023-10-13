import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:5000/api/banks_trans';

class API_BankTrans {
  //get all banks trans
  static Future Get_all (token) async{
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
  //add banks
  static Future Add (data, token) async{
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl');
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
  //find one one bank
  static Future Find (data, token) async{
    try{
      Map<String,String> requestHeaders = {
        'Content-Type' : 'application/json',
        'x-auth-token' : '$token'
      };

      final url = Uri.parse('$apiUrl/get-date');
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
  //delete one bank
  static Future Delete (data, token) async{
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