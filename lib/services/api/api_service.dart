import 'dart:convert';
import 'dart:io';
import 'package:alice_store/utils/private_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

//Util class to get general response from the API
class ApiService{
  //final String baseApiUrl = 'http://${PrivateConstants.ip}:3000';
  final String baseApiUrl = PrivateConstants.serverUrl;
  Future<dynamic> getResponse(String url) async{
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(baseApiUrl + url));
      //Decode the response and return the json body to be mapped to any object
      responseJson = jsonDecode(response.body);
    } on SocketException catch (e){
      print(baseApiUrl+url);
      // Handle the SocketException
      dev.log('Network connection error: $e');
    }catch(e){
      dev.log('Random Exception $e');
    }
    return responseJson;
  }
}