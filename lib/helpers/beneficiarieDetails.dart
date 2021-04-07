import 'dart:convert';
import 'dart:io';
import 'package:eduempower/models/beneficiarieDetails.dart'
    as beneficiarieDetails_model;
import 'package:eduempower/models/beneficiarieDataFields.dart'
    as beneficiarieDataFields_model;

import 'package:http/http.dart' as http;
import 'package:eduempower/models/response.dart';

class BeneficiarieDetails {
  Future<List<beneficiarieDetails_model.BeneficiarieDetails>> getBeneficiaries(
      String url, String token, int skip, int limit, String status) async {
    final response = await http.get(
        Uri.parse(url +
            "/" +
            skip.toString() +
            "/" +
            limit.toString() +
            "?statusForFunding=" +
            status),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      if (l != null) {
        List<beneficiarieDetails_model.BeneficiarieDetails> list = l
            .map((model) =>
                beneficiarieDetails_model.BeneficiarieDetails.fromJson(model))
            .toList();
        return list;
      } else {
        return null;
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<GeneralResponse> addBenificiarieDetails(String url, token,
      beneficiarieDetails_model.BeneficiarieDetails body) async {
    var response =
        await http.post(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<GeneralResponse> updateBenificiarieFileds(String url, token,
      beneficiarieDataFields_model.BeneficiarieDataFields body) async {
    var response =
        await http.put(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<GeneralResponse> updateBenificiarieDetailsById(
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
