import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  //final String _url = 'https://italiaqualificagroup.org/api/';

  postData(data, apiUrl) async {
    /*var fullUrl;
    if (data['endpoint'] == "")
      fullUrl = _url + apiUrl;
    else*/
    var fullUrl = 'https://' +
        data['endpoint'] +
        '.italiaqualificagroup.org/api/' +
        apiUrl;

    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = apiUrl + await _getToken();
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getData1(data, apiUrl) async {
    var fullUrl = 'https://' +
        data +
        '.italiaqualificagroup.org/api/' +
        apiUrl +
        await _getToken();

    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getTasks(endpoint) async {
    /*var fullUrl;
    if (endpoint == "")
      fullUrl*/
    var fullUrl =
        'https://' + endpoint + '.italiaqualificagroup.org/api/' + 'task';

    return await http.get(Uri.parse(fullUrl), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ' + await _getToken()
    });
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _setAuthHeaders() => {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + _getTokenAuth()
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token;
  }

  _getTokenAuth() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return await token;
  }
}
