class FundRequest {
  final String id;
  final num fundRequired;
  final String fundRequiredBy;
  final String moreInfo;
  final String lastUpdated;
  final String status;

  FundRequest(
      {this.id,
      this.fundRequired,
      this.fundRequiredBy,
      this.moreInfo,
      this.lastUpdated,
      this.status});

  factory FundRequest.fromJson(Map<String, dynamic> json) {
    return FundRequest(
        id: json['id'],
        fundRequiredBy: json["fundRequiredBy"],
        fundRequired: json['fundRequired'],
        moreInfo: json['moreInfo'],
        status: json['status'],
        lastUpdated: json['lastUpdated']);
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["fundRequired"] = fundRequired;
    map["fundRequiredBy"] = fundRequiredBy;
    map["moreInfo"] = moreInfo;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fundRequired": fundRequired,
        "fundRequiredBy": fundRequiredBy,
        "moreInfo": moreInfo,
        "status": status,
        "lastUpdated": lastUpdated,
      };
}
