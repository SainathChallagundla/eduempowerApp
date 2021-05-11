class Donation {
  final String id;
  final String did;
  final String bid;
  final num proposedAmount;
  final num receivedAmount;
  final String moreInfo;
  DonationStatusFields currentStatus;
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
      //currentStatus: json['currentStatus'],
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
  String id;
  String info;
  String status;
  String statusOn;
  String statusBy;
  DonationStatusFields(
      {this.id, this.info, this.status, this.statusOn, this.statusBy});

  factory DonationStatusFields.fromJson(Map<String, dynamic> json) {
    return DonationStatusFields(
      id: json['id'],
      info: json['info'],
      status: json['status'],
      statusOn: json['statusOn'],
      statusBy: json['statusBy'],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "info": info,
        "status": status,
        "statusOn": statusOn,
        "statusBy": statusBy,
      };
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["info"] = info;
    map["status"] = status;
    map["statusOn"] = statusOn;
    map["statusBy"] = statusBy;
    return map;
  }
}
