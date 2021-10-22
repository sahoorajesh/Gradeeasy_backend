import '../page2.dart';

class ConfirmPassResponseModel {
  final String status;
  final String error;

  ConfirmPassResponseModel({this.status,this.error});

  factory ConfirmPassResponseModel.fromJson(Map<String, dynamic> json) {
    return ConfirmPassResponseModel(
      status: json["status"] != null ? json["status"] : "ok",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class ConfirmpassRequestModel {

  String token;
  String password;

  ConfirmpassRequestModel({
    this.token,
    this.password

  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {

      'token': reset_token,
      'password': password

    };

    return map;
  }
}
