import 'beneficiarieTemplate.dart';

class BeneficiarieDocuments {
  final String id;
  final List<Document> documents;

  BeneficiarieDocuments({
    this.id,
    this.documents,
  });

  factory BeneficiarieDocuments.fromJson(Map<String, dynamic> json) {
    var list = json['documents'] as List;

    List<Document> documentsList =
        list.map((i) => Document.fromJson(i)).toList();

    return BeneficiarieDocuments(
      id: json['id'],
      documents: documentsList,
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;

    map["documents"] = documents;

    return map;
  }
}
