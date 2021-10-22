import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Viewgrade_model.dart';



class Viewgrade_APIService {
  Future<ViewgradeResponseModel> viewgrade(ViewgradeRequestModel requestModel) async {
    String url = "http://10.0.2.2:8000/grading/grade/";

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200) {
      return ViewgradeResponseModel.fromJson(
        json.decode(response.body.toString()),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }
}