import 'package:eduempower/models/response.dart';
import 'package:eduempower/models/donations.dart' as fund_model;
import 'package:eduempower/models/fundRequest.dart' as fundrequest_model;
import 'package:eduempower/models/fundRequest.dart' as for_donarid;
import 'package:eduempower/models/beneficiariefundRequests.dart'
    as bfund_request;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:eduempower/models/common.dart' as common_details;

class FundDetails {
  Future<GeneralResponse> addDonation(
      String url, token, fund_model.Donation body) async {
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

  Future<List<fund_model.Donation>> getDonationByDonar(
      String url, String token, int skip, int limit, String id) async {
    final response = await http.get(
        Uri.parse(url +
            "/" +
            skip.toString() +
            "/" +
            limit.toString() +
            "?_did=" +
            id),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      print(response.body);
      Iterable l = json.decode(response.body);
      if (l != null) {
        List<fund_model.Donation> list =
            l.map((model) => fund_model.Donation.fromJson(model)).toList();
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
        await http.put(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    print(response.body);
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<bfund_request.BeneficiarieFundRequests> getBeneficiarieFundRequest(
      String url, String id, String token, int skip, int limit) async {
    final response = await http.get(
        Uri.parse(
            url + "/" + id + "/" + skip.toString() + "/" + limit.toString()),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return bfund_request.BeneficiarieFundRequests.fromJson(
          json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<for_donarid.FundRequest> getDonarId(
    String url,
    String token,
  ) async {
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return for_donarid.FundRequest.fromJson(json.decode(response.body));
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

  Future<common_details.BeneficiarieData> common(
    String url,
    String id,
    String token,
  ) async {
    final response = await http.get(Uri.parse(url + id),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return common_details.BeneficiarieData.fromJson(
          json.decode(response.body));
      // return BeneficiarieDetails.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }
}
