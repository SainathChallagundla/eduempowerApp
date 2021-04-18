class Fund {
  final String id;
  final String name;
  final num amountProposed;
  final num amountReceived;
  final String donorEmail;
  final String currency;
  final String modeOfPayment;
  final String referenceNo;
  final String moreInfo;
  List<FundStatusFields> fundStatus;
  final String status;
  final String lastUpdated;

  Fund({
    this.name,
    this.id,
    this.amountProposed,
    this.amountReceived,
    this.donorEmail,
    this.currency,
    this.modeOfPayment,
    this.referenceNo,
    this.moreInfo,
    this.fundStatus,
    this.status,
    this.lastUpdated,
  });

  factory Fund.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    var fs = json['fundStatus'] as List;

    List<FundStatusFields> fundStatus =
        fs.map((i) => FundStatusFields.fromJson(i)).toList();

    return Fund(
      id: json['id'],
      name: json['name'],
      amountProposed: json['amountProposed'],
      amountReceived: json['amountReceived'],
      donorEmail: json['donorEmail'],
      currency: json['currency'],
      modeOfPayment: json['modeOfPayment'],
      referenceNo: json['referenceNo'],
      moreInfo: json['moreInfo'],
      fundStatus: fundStatus,
      status: json['status'],
      lastUpdated: json['lastUpdated'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["amountProposed"] = amountProposed;
    map["amountReceived"] = amountReceived;
    map["donorEmail"] = donorEmail;
    map["currency"] = currency;
    map["modeOfPayment"] = modeOfPayment;
    map["referenceNo"] = referenceNo;
    map["moreInfo"] = moreInfo;
    map["fundStatus"] = fundStatus;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;

    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amountProposed": amountProposed,
        "amountReceived": amountReceived,
        "donorEmail": donorEmail,
        "currency": currency,
        "modeOfPayment": modeOfPayment,
        "referenceNo": referenceNo,
        "moreInfo": moreInfo,
        "fundStatus": fundStatus,
        "status": status,
        "lastUpdated": lastUpdated,
      };
}

class FundStatusFields {
  String Status;
  String StatusdOn;
  String StatusBy;
  String Notes;
  FundStatusFields({
    this.Status,
    this.StatusdOn,
    this.StatusBy,
    this.Notes,
  });

  factory FundStatusFields.fromJson(Map<String, dynamic> json) {
    return FundStatusFields(
      Status: json['status'],
      StatusdOn: json['date'],
      StatusBy: json['donorEmail'],
      Notes: json['moreInfo'],
    );
  }
  Map<String, dynamic> toJson() => {
        "status": Status,
        "date": StatusdOn,
        "donorEmail": StatusBy,
        "moreInfo": Notes,
      };
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["staus"] = Status;
    map["date"] = StatusdOn;
    map["donorEmail"] = StatusBy;
    map["moreInfo"] = Notes;
    return map;
  }
}
