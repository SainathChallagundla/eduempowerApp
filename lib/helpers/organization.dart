import 'dart:convert';
import 'dart:io';
import 'package:eduempower/models/organization.dart' as individual_model;
import 'package:http/http.dart' as http;
import 'package:eduempower/models/response.dart';

class Organization {
  Future<individual_model.Organization> getOrganization(
      String url, String email, String token) async {
    try {
      final response = await http.get(Uri.parse(url + email),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
        // print(individual_model.Individual.fromJson(json.decode(response.body)).user.email);
        return individual_model.Organization.fromJson(
            json.decode(response.body));
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to fetch data');
      }
    } on HttpException catch (e) {
      print(e);
      return null;
    }
  }

  Future<GeneralResponse> updateOrganization(
      String url, id, token, individual_model.Organization body) async {
    print(id);
    // var response = await http.put(url+id, body: json.encode(body), headers: {
    //   "accept": "application/json",
    //   "content-type": "application/json",
    //   HttpHeaders.authorizationHeader: 'Bearer $token',
    // });
    // return GeneralResponse.fromJson(
    //     json.decode(response.body), response.statusCode);
  }
}
