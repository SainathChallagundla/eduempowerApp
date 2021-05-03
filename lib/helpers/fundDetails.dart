import 'package:eduempower/models/response.dart';
import 'package:eduempower/models/funds.dart' as fund_model;
import 'package:eduempower/models/fundRequest.dart' as fundrequest_model;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class FundDetails {
  Future<GeneralResponse> addFund(
      String url, token, fund_model.Fund body) async {
    var response =
        await http.post(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    print(response.body);
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<List<fund_model.Fund>> getFundsByDonar(
      String url, String token, int skip, int limit, String email) async {
    final response = await http.get(
        Uri.parse(url +
            "/" +
            skip.toString() +
            "/" +
            limit.toString() +
            "?donorEmail=" +
            email),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable l = json.decode(response.body);
      if (l != null) {
        List<fund_model.Fund> list =
            l.map((model) => fund_model.Fund.fromJson(model)).toList();
        return list;
      } else {
        return null;
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<GeneralResponse> addFundRequest(
      String url, token, fundrequest_model.FundRequest body) async {
    var response =
        await http.post(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    print(response.body);
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<fundrequest_model.FundRequest> getFundRequestById(
      String url, String id, String token) async {
    final response = await http.get(Uri.parse(url + id),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return fundrequest_model.FundRequest.fromJson(json.decode(response.body));
      // return BeneficiarieDetails.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<fundrequest_model.FundRequest> deleteFundRequestById(
      String url, String id, String token) async {
    final response = await http.delete(Uri.parse(url + id),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
    } else {
      print("------------------------------------------------------");
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<GeneralResponse> updatefundRequestById(
      String url, token, Map<String, dynamic> body) async {
    var response =
        await http.put(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }
}
