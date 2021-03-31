import 'beneficiarieDetails.dart';

class BeneficiarieDataFields {
  List<TemplateDataFields> data;
 
  BeneficiarieDataFields(
      {
      this.data,
      });

  factory BeneficiarieDataFields.fromJson(Map<String, dynamic> json) {

   var list = json['data'] as List;
  
    List<TemplateDataFields> dataList = list.map((i) => TemplateDataFields.fromJson(i)).toList();

    return BeneficiarieDataFields(
      data: dataList,
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
   
    map["data"] = data;
   
    return map;
  }
    Map<String, dynamic> toJson() => {
        "data":data,
    };
}

