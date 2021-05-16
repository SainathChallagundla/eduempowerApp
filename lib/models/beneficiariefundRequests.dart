import 'fundRequest.dart';

class BeneficiarieFundRequests {
  final String id;
  final List<FundRequest> fundRequest;

  BeneficiarieFundRequests({
    this.id,
    this.fundRequest,
  });

  factory BeneficiarieFundRequests.fromJson(Map<String, dynamic> json) {
    var list = json['fundRequest'] as List;

    List<FundRequest> fundRequest =
        list.map((i) => FundRequest.fromJson(i)).toList();

    return BeneficiarieFundRequests(
      id: json['id'],
      fundRequest: fundRequest,
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;

    map["fundRequest"] = fundRequest;

    return map;
  }
}
