class KeyValueModel{
  String? key;
  String? value;

  KeyValueModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }


}