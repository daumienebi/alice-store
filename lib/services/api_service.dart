import 'dart:convert';
import 'dart:io';
import 'package:alice_store/utils/private_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

//Util class to get general response from the API
class ApiService{
  final String baseApiUrl = 'http://${PrivateConstants.ip}:3000';
  Future<dynamic> getResponse(String url) async{
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(baseApiUrl + url));
      //Decode the response and return the json body to be mapped to any object
      responseJson = jsonDecode(response.body);
    } on SocketException catch (e){
      // Handle the SocketException
      dev.log('There was a problem with the network connection: $e');
    }catch(e){
      dev.log('random exception $e');
    }
    return responseJson;
  }
}