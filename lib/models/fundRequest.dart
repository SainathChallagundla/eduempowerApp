class FundRequest {
  final String id;
  final String beneficiarieID;
  final num fundRequired;
  final String moreInfo;
  final String lastUpdated;
  final String status;

  FundRequest(
      {this.id,
      this.beneficiarieID,
      this.fundRequired,
      this.moreInfo,
      this.lastUpdated,
      this.status});

  factory FundRequest.fromJson(Map<String, dynamic> json) {
    return FundRequest(
        id: json['id'],
        beneficiarieID: json['beneficiarieID'],
        fundRequired: json['fundRequired'],
        moreInfo: json['moreInfo'],
        status: json['status'],
        lastUpdated: json['lastUpdated']);
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["beneficiarieID"] = beneficiarieID;
    map["fundRequired"] = fundRequired;
    map["moreInfo"] = moreInfo;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "beneficiarieID": beneficiarieID,
        "fundRequired": fundRequired,
        "moreInfo": moreInfo,
        "status": status,
        "lastUpdated": lastUpdated,
      };
}
