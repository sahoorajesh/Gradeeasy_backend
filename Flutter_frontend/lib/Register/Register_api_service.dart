import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Register_model.dart';

class Register_APIService {
  Future<RegisterResponseModel> register(RegisterRequestModel requestModel) async {
    String url = "http://10.0.2.2:8000/api/register/";

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegisterResponseModel.fromJson(
        json.decode(response.body.toString()),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }
}