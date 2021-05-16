import 'package:eduempower/models/beneficiarieDetails.dart';
import 'package:eduempower/models/user.dart';
import 'package:eduempower/models/donations.dart';

class BeneficiarieData {
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
  BeneficiarieDetails beneficiarie;
  User donar;

  BeneficiarieData(
      {this.id,
      this.did,
      this.bid,
      this.proposedAmount,
      this.receivedAmount,
      this.moreInfo,
      this.currentStatus,
      this.donationStatus,
      this.status,
      this.lastUpdated,
      this.beneficiarie,
      this.donar});

  factory BeneficiarieData.fromJson(Map<String, dynamic> json) {
    var dslist = json['donationStatus'] as List;
    // var bslist = json['beneficiarie'] as List;
    List<DonationStatusFields> donationStatus =
        dslist.map((i) => DonationStatusFields.fromJson(i)).toList();
    // List<BeneficiarieDetails> beneficiarie =
    //     bslist.map((i) => BeneficiarieDetails.fromJson(i)).toList();

    return BeneficiarieData(
      id: json['id'],
      did: json['did'],
      bid: json['bid'],
      proposedAmount: json['proposedAmount'],
      receivedAmount: json['receivedAmount'],
      moreInfo: json['moreInfo'],
      currentStatus: DonationStatusFields.fromJson(json['currentStatus']),
      donationStatus: donationStatus,
      status: json['status'],
      lastUpdated: json['lastUpdated'],
      beneficiarie: BeneficiarieDetails.fromJson(json['beneficiarie']),
      donar: User.fromJson(json['donar']),
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['did'] = did;
    map['bid'] = bid;
    map['proposedAmount'] = proposedAmount;
    map['receivedAmount'] = receivedAmount;
    map['moreInfo'] = moreInfo;
    map['currentStatus'] = currentStatus;
    map['donationStatus'] = donationStatus;
    map['status'] = status;
    map['lastUpdated'] = lastUpdated;
    map['beneficiarie'] = beneficiarie;
    map['donar'] = donar;
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'did': did,
        'bid': bid,
        'proposedAmount': proposedAmount,
        'receivedAmount': receivedAmount,
        'moreInfo': moreInfo,
        'currentStatus': currentStatus,
        'donationStatus': donationStatus,
        'status': status,
        'lastUpdated': lastUpdated,
        'beneficiarie': beneficiarie,
        'donar': donar,
      };
}
