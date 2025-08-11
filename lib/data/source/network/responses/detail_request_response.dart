class DetailRequestResponse {
  int? id;
  int? requestTypeId;
  String? requestName;
  String? phoneNumber;
  String? requestKey;
  String? info;
  String? photo;
  String? status;
  String? clientInitial;

  DetailRequestResponse(
      {this.id,
        this.phoneNumber,
        this.requestTypeId,
        this.requestName,
        this.requestKey,
        this.info,
        this.status,
        this.clientInitial,
        this.photo});

  DetailRequestResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phone_number'];
    requestTypeId = json['request_type_id'];
    requestName = json['request_name'];
    requestKey = json['request_key'];
    info = json['info'];
    photo = json['photo'];
    status = json['status'];
    clientInitial = json['client_initial'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['phone_number'] = phoneNumber;
    data['request_type_id'] = requestTypeId;
    data['request_name'] = requestName;
    data['request_key'] = requestKey;
    data['info'] = info;
    data['photo'] = photo;
    data['status'] = status;
    return data;
  }
}