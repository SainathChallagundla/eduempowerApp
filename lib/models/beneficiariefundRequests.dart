import 'fundRequest.dart';

class BeneficiarieFundRequests {
  final String id;
  final List<FundRequest> fundRequests;

  BeneficiarieFundRequests({
    this.id,
    this.fundRequests,
  });

  factory BeneficiarieFundRequests.fromJson(Map<String, dynamic> json) {
    var list = json['fundRequest'] as List;

    List<FundRequest> fundrequestsList =
        list.map((i) => FundRequest.fromJson(i)).toList();

    return BeneficiarieFundRequests(
      id: json['id'],
      fundRequests: fundrequestsList,
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;

    map["fundRequest"] = fundRequests;

    return map;
  }
}
