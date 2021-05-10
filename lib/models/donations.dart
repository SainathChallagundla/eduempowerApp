class Donation {
  final String id;
  final String did;
  final String bid;
  final num proposedAmount;
  final num receivedAmount;
  final String moreInfo;
  final DonationStatusFields currentStatus;
  List<DonationStatusFields> donationStatus;
  final String status;
  final String lastUpdated;

  Donation({
    this.id,
    this.did,
    this.bid,
    this.proposedAmount,
    this.receivedAmount,
    this.moreInfo,
    this.currentStatus,
    this.donationStatus,
    this.status,
    this.lastUpdated,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    var ds = json['donationStatus'] as List;
    List<DonationStatusFields> donationStatus =
        ds.map((i) => DonationStatusFields.fromJson(i)).toList();

    return Donation(
      id: json['id'],
      did: json['did'],
      bid: json['bid'],
      proposedAmount: json['proposedAmount'],
      receivedAmount: json['receivedAmount'],
      moreInfo: json['moreInfo'],
      currentStatus: json['currentStatus'],
      donationStatus: donationStatus,
      status: json['status'],
      lastUpdated: json['lastUpdated'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["did"] = did;
    map["bid"] = bid;
    map["proposedAmount"] = proposedAmount;
    map["receivedAmount"] = receivedAmount;
    map["moreInfo"] = moreInfo;
    map["currentStatus"] = currentStatus;
    map["donationStatus"] = donationStatus;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;

    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "did": did,
        "bid": bid,
        "proposedAmount": proposedAmount,
        "receivedAmount": receivedAmount,
        "moreInfo": moreInfo,
        "currentStatus": currentStatus,
        "donationStatus": donationStatus,
        "status": status,
        "lastUpdated": lastUpdated,
      };
}

class DonationStatusFields {
  String Id;
  String Info;
  String Status;
  String StatusdOn;
  String StatusBy;
  DonationStatusFields({
    this.Id,
    this.Info,
    this.Status,
    this.StatusdOn,
    this.StatusBy,
  });

  factory DonationStatusFields.fromJson(Map<String, dynamic> json) {
    return DonationStatusFields(
      Id: json['id'],
      Info: json['info'],
      Status: json['status'],
      StatusdOn: json['statusOn'],
      StatusBy: json['statusBy'],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": Id,
        "info": Info,
        "status": Status,
        "statusOn": StatusdOn,
        "statusBy": StatusBy,
      };
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = Id;
    map["info"] = Info;
    map["staus"] = Status;
    map["statusOn"] = StatusdOn;
    map["statusBy"] = StatusBy;
    return map;
  }
}
