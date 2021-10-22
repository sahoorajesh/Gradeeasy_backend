
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Confirm_pass_model.dart';



// ignore: camel_case_types
class ConfirmPass_APIService {
  Future<ConfirmPassResponseModel> confirmpass(ConfirmpassRequestModel requestModel) async {
    String url = "http://10.0.2.2:8000/api/password_reset/confirm";

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return ConfirmPassResponseModel.fromJson(
        json.decode(response.body.toString()),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }
}