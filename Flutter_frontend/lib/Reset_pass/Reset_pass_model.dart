class ResetResponseModel {
  final String token;
  //final String error;

  ResetResponseModel({this.token});

  factory ResetResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetResponseModel(
      token: json["token"] != null ? json["token"] : "",
      //error: json["error"] != null ? json["error"] : "",
    );
  }
}

class ResetRequestModel {

  String email;


  ResetRequestModel({
    this.email,

  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {

      'email': email,

    };

    return map;
  }
}
