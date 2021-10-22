import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Reset_pass_model.dart';

// ignore: camel_case_types
class Reset_APIService {
  Future<ResetResponseModel> reset(ResetRequestModel requestModel) async {
    String url = "http://10.0.2.2:8000/api/password_reset/";

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return ResetResponseModel.fromJson(
        json.decode(response.body.toString()),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }
}