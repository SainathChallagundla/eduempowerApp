import 'dart:convert';
import 'dart:io';
import 'package:eduempower/models/individual.dart' as individual_model;
import 'package:http/http.dart' as http;
import 'package:eduempower/models/response.dart';
import 'package:eduempower/helpers/httphelper.dart';

class Individual {
  Future<individual_model.Individual> getIndividual(
      String url, String email, String token) async {
    final response = await http.get(Uri.parse(url + email),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      // print(individual_model.Individual.fromJson(json.decode(response.body)).user.email);
      return individual_model.Individual.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to fetch data');
    }
  }

  Future<GeneralResponse> updateIndividual(
      String url, id, token, individual_model.Individual body) async {
    print(id);
    print(Uri.parse(url + id));
    var response =
        await http.put(Uri.parse(url + id), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }
}
