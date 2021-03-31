import 'beneficiarieTemplate.dart';

class BeneficiarieDetails {
  final String id;
  final String name;
  final String templateName;
   List<TemplateDataFields> data;
   List<Document> documents;
   String statusForFunding;
  final String status;
  final String lastUpdated;
  final String user;

  BeneficiarieDetails(
      {this.id,
      this.name,
      this.templateName,
      this.data,
      this.documents,
      this.statusForFunding,
      this.status,
      this.lastUpdated,
      this.user});

  factory BeneficiarieDetails.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;

    var docs = json['documents'] as List;
  
    List<TemplateDataFields> templateDataFieldsList = list.map((i) => TemplateDataFields.fromJson(i)).toList();
    List<Document> documents = docs.map((i) => Document.fromJson(i)).toList();

    return BeneficiarieDetails(
      id: json['id'],
      name: json['name'],
      templateName: json['templateName'],
      data: templateDataFieldsList,
      documents:documents,
      statusForFunding:json['statusForFunding'],
      status: json['status'],
      lastUpdated: json['lastUpdated'],
      user: json['user'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["templateName"] = templateName;
    map["templateDataFields"] = data;
    map['documents']=documents;
    map['statusForFunding']=statusForFunding;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;
    map['user'] = user;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "templateName": templateName,
        "data":data,
        "documents":documents,
        "statusForFunding":statusForFunding,
        "status":status,
        "lastUpdated":lastUpdated,
        "user":user
    };
}

class TemplateDataFields {
   String name;
   String header;
   String value;
   String type;
   bool required;
   String regex;
   Verification verification;
  TemplateDataFields(
      {this.name,
      this.header,
      this.value,
      this.type,
      this.required,
      this.regex,
      this.verification
    });

  factory TemplateDataFields.fromJson(Map<String, dynamic> json) {
    return TemplateDataFields(
      name: json['name'],
      header: json['header'],
      value: json['value'],
      type: json['type'],
      required: json['required'],
      regex: json['regex'],
      verification: Verification.fromJson(json['verification']),
    );
  }
 Map<String, dynamic> toJson() => {
        "name": name,
        "header": header,
        "value": value,
        "type":type,
        "required":required,
        "regex":regex,
        "verification":verification,
    };
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["header"] = header;
    map["value"] = value;
    map["type"] = type;
    map["required"] = required;
    map["regex"] = regex;
    map["verification"] = verification;
    return map;
  }
}
