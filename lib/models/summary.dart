class Summary {
  final num noofBenificiaries;
  final num noofContributors;
  final num noofDonars;
  final num fundsCollected;
  final num fundsContributed;

  Summary({
    this.noofBenificiaries,
    this.noofContributors,
    this.noofDonars,
    this.fundsCollected,
    this.fundsContributed,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      noofBenificiaries: json['no_of_beneficiaries'],
      noofContributors: json['no_of_contributors'],
      noofDonars: json['no_of_donors'],
      fundsCollected: json['total_funds_collected'],
      fundsContributed: json['total_funds_contributerd'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["no_of_beneficiaries"] = noofBenificiaries;
    map["no_of_contributors"] = noofContributors;
    map["no_of_donors"] = noofDonars;
    map["total_funds_collected"] = fundsCollected;
    map["total_funds_contributerd"] = fundsContributed;

    return map;
  }

  Map<String, dynamic> toJson() => {
        "no_of_beneficiaries": noofBenificiaries,
        "no_of_contributors": noofContributors,
        "no_of_donors": noofDonars,
        "total_funds_collected": fundsCollected,
        "total_funds_contributerd": fundsContributed,
      };
}
