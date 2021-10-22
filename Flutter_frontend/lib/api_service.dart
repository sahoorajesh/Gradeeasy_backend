import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    String url = "http://10.0.2.2:8000/api/login/";

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(
        json.decode(response.body.toString()),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }
}