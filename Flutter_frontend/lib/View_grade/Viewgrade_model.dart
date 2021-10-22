class ViewgradeResponseModel {
  final String Final_Grade;
  final String error;

  ViewgradeResponseModel({this.Final_Grade, this.error});

  factory ViewgradeResponseModel.fromJson(Map<String, dynamic> json) {
    return ViewgradeResponseModel(
      Final_Grade: json["Final Grade"] != null ? json["Final Grade"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class ViewgradeRequestModel {


  ViewgradeRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {

    };

    return map;
  }
}