import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect.dart';

import '../utility/constants.dart';

import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = MAIN_URL;

 Future<http.Response> getItems({required String endpointUrl}) async {
  final String fullUrl = '$baseUrl/$endpointUrl';

  try {
    final response = await http.get(Uri.parse(fullUrl));
    return response;
  } catch (e) {
    return http.Response(json.encode({'error': e.toString()}), 500);
  }
}

  Future<Response> addItem(
      {required String endpointUrl, required dynamic itemData}) async {
    try {
      final response =
          await GetConnect().post('$baseUrl/$endpointUrl', itemData);
      print(response.body);
      return response;
    } catch (e) {
      print('Error: $e');
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> updateItem(
      {required String endpointUrl,
      required String itemId,
      required dynamic itemData}) async {
    try {
      return await GetConnect().put('$baseUrl/$endpointUrl/$itemId', itemData);
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem(
      {required String endpointUrl, required String itemId}) async {
    try {
      return await GetConnect().delete('$baseUrl/$endpointUrl/$itemId');
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }
}
