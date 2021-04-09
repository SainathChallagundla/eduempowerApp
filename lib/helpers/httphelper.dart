import 'dart:convert';
import 'dart:io';
import 'package:eduempower/models/response.dart';
import 'package:eduempower/models/beneficiarieTemplate.dart';
import 'package:eduempower/models/beneficiarieDetails.dart';
import 'package:eduempower/models/beneficiarieDataFields.dart';
import 'package:eduempower/models/beneficiarieDocuments.dart';
import 'package:eduempower/models/user.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  Future<GeneralResponse> post(String url, {Map body}) async {
    var response = await http.post(Uri.parse(url),
        body: json.encode(body),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        });
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(
          json.decode(response.body), response.statusCode);
    } else {
      print("Coming here-------------");
      throw Exception("Failed due to network issue");
    }
  }

  Future<GeneralResponse> submit(String url, token, {Map body}) async {
    var response =
        await http.post(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(
          json.decode(response.body), response.statusCode);
    } else {
      throw Exception("Failed due to network issue");
    }
  }

  Future<GeneralResponse> submitBenificiarieDetails(
      String url, token, BeneficiarieDetails body) async {
    var response =
        await http.post(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<GeneralResponse> submitBenificiarieFileds(
      String url, token, BeneficiarieDataFields body) async {
    var response =
        await http.put(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<GeneralResponse> submitBenificiarieDocument(
      String url, token, Document body) async {
    var response =
        await http.put(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<User> fetchUser(String email, String url, String token) async {
    final response = await http.get(Uri.parse(url + email),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return User.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List> getTemplateNames(String url, String token) async {
    List data = new List();
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      return data;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<BeneficiarieTemplate> getTemplateData(
      String url, String template, String token) async {
    final response = await http.get(Uri.parse(url + template),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return BeneficiarieTemplate.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<BeneficiarieDetails>> getBeneficiaries(
      String url, String token, int skip, int limit) async {
    final response = await http.get(
        Uri.parse(url + "/" + skip.toString() + "/" + limit.toString()),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      if (l != null) {
        List<BeneficiarieDetails> list =
            l.map((model) => BeneficiarieDetails.fromJson(model)).toList();
        return list;
      } else {
        return null;
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<BeneficiarieDocuments> getBeneficiarieDocuments(
      String url, String id, String token, int skip, int limit) async {
    final response = await http.get(
        Uri.parse(
            url + "/" + id + "/" + skip.toString() + "/" + limit.toString()),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return BeneficiarieDocuments.fromJson(json.decode(response.body));
      // return BeneficiarieDetails.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<BeneficiarieDetails> getBeneficiarieById(
      String url, String id, String token) async {
    final response = await http.get(Uri.parse(url + id),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return BeneficiarieDetails.fromJson(json.decode(response.body));
      // return BeneficiarieDetails.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }
}

//192.168.0.106  ubuntu//109  ////MainServer   51.195.137.55
class HttpEndPoints {
  static const String BASE_URL = "http://192.168.0.105:50051/";

  static const String SIGN_IN = "v1/public/user/mobile/signin";
  static const String REGISTER = "v1/public/user/register";
  static const String RESETPASSWORD = "v1/public/user/resetPassword";
  static const String GET_USER = "v1/user/get/";
  static const String GET_INDIVIDUAL = "v1/user/individual/get/";
  static const String UPDATE_INDIVIDUAL = "v1/user/individual/updateBy/";
  static const String GET_ORGANIZATION = "v1/user/organization/get/";
  static const String UPDATE_ORGANIZATION = "v1/user/organization/updateBy/";

  static const String GET_TEMPLATE_NAMES =
      "v1/user/beneficiarie/template/getTemplateNames";
  static const String GET_TEMPLATE = "v1/user/beneficiarie/template/get/";

  static const String ADD_BENEFICIARY_DETAILS =
      "v1/user/beneficiarie/details/add";

  static const String UPDATE_BENEFICIARIE_FIELDS =
      "v1/user/beneficiarie/details/UpdateBeneficiarieDataById/";

  static const String UPDATE_BENEFICIARIE_DETAILS_ID =
      "v1/user/beneficiarie/details/UpdateBeneficiarieDetailsById/";

  static const String GET_BENEFICIARIES =
      "v1/user/beneficiarie/details/getBeneficiaries";

  static const String GET_BENEFICIARIEBYID =
      "v1/user/beneficiarie/details//getById/";

  static const String GET_BENEFICIARIE_DOCUMENTS =
      "v1/user/beneficiarie/details/getBeneficiarieDocuments/";

  static const String ADD_BENEFICIARIE_DOCUMENT =
      "v1/user/beneficiarie/details/document/add/";

  static const String GET_FILE = "v1/public/user/getFile/";

  static const String ADD_FUND = "v1/fund/add";
}
