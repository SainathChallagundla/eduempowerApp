class FundRequest {
  final String id;
  final num fundRequired;
  final String fundRequiredBy;
  final num receivedAmount;
  final String moreInfo;
  final String status;
  final String lastUpdated;

  FundRequest({
    this.id,
    this.fundRequired,
    this.fundRequiredBy,
    this.receivedAmount,
    this.moreInfo,
    this.status,
    this.lastUpdated,
  });

  factory FundRequest.fromJson(Map<String, dynamic> json) {
    return FundRequest(
      id: json['id'],
      fundRequired: json['fundRequired'],
      fundRequiredBy: json['fundRequiredBy'],
      receivedAmount: json['receivedAmount'],
      moreInfo: json['moreInfo'],
      status: json['status'],
      lastUpdated: json['lastUpdated'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["fundRequired"] = fundRequired;
    map["fundRequiredBy"] = fundRequiredBy;
    map["receivedAmount"] = receivedAmount;
    map["moreInfo"] = moreInfo;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fundRequired": fundRequired,
        "fundRequiredBy": fundRequiredBy,
        "receivedAmount": receivedAmount,
        "moreInfo": moreInfo,
        "status": status,
        "lastUpdated": lastUpdated,
      };
}
