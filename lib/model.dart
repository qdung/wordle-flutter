class APIResponse {
  int? slot;
  String? guess;
  String? result;

  APIResponse({this.slot, this.guess, this.result});

  APIResponse.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
    guess = json['guess'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot'] = this.slot;
    data['guess'] = this.guess;
    data['result'] = this.result;
    return data;
  }
}
