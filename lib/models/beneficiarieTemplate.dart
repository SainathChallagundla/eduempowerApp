class BeneficiarieTemplate {
  final String id;
  final String templateName;
  final List<TemplateFields> templateFields;
  final String status;
  final String lastUpdated;
  BeneficiarieTemplate(
      {this.id,
      this.templateName,
      this.templateFields,
      this.status,
      this.lastUpdated});

  factory BeneficiarieTemplate.fromJson(Map<String, dynamic> json) {
    var list = json['templateFields'] as List;

    List<TemplateFields> templateFieldsList =
        list.map((i) => TemplateFields.fromJson(i)).toList();

    return BeneficiarieTemplate(
      id: json['id'],
      templateName: json['templateName'],
      templateFields: templateFieldsList,
      status: json['status'],
      lastUpdated: json['lastUpdated'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["templateName"] = templateName;
    map["templateFields"] = templateFields;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;
    return map;
  }
}

class Verification {
  final bool toBeVerified;
  String verifiedBy;
  String status;

  Verification({this.toBeVerified, this.verifiedBy, this.status});

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      toBeVerified: json['toBeVerified'],
      verifiedBy: json['verifiedBy'],
      status: json['status'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["toBeVerified"] = toBeVerified;
    map["verifiedBy"] = verifiedBy;
    map["status"] = status;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "toBeVerified": toBeVerified,
        "verifiedBy": verifiedBy,
        "status": status
      };
}

class Document {
  final String documentType;
  final String documentName;
  final String documentId;
  Document({
    this.documentType,
    this.documentName,
    this.documentId,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
        documentType: json['documentType'],
        documentName: json['documentName'],
        documentId: json['documentId']);
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["documentType"] = documentType;
    map["documentName"] = documentName;
    map["documentId"] = documentId;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "documentType": documentType,
        "documentName": documentName,
        "documentId": documentId
      };
}

class TemplateFields {
  final String name;
  final String header;
  final String type;
  final bool required;
  final String regex;
  final String mainHeader;
  final Verification verification;
  TemplateFields(
      {this.name,
      this.header,
      this.type,
      this.required,
      this.regex,
      this.mainHeader,
      this.verification});

  factory TemplateFields.fromJson(Map<String, dynamic> json) {
    return TemplateFields(
      name: json['name'],
      header: json['header'],
      type: json['type'],
      required: json['required'],
      regex: json['regex'],
      mainHeader: json["mainHeader"],
      verification: Verification.fromJson(json['verification']),
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["header"] = header;
    map["type"] = type;
    map["required"] = required;
    map["regex"] = regex;
    map["mainHeader"] = mainHeader;
    map["verification"] = verification;
    return map;
  }
}
