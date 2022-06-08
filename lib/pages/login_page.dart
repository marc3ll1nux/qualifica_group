import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'package:qualifica_group/api/api.dart';
import 'package:qualifica_group/common/theme_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';

import 'widgets/header_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? dataconf;

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController endpoint = TextEditingController(text: "");

  // ScaffoldState scaffoldState;
  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Chiudi',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkIfLoggedIn();

    super.initState();
  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      _loadData();
    }
  }

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/configuration.txt');
  }

  Future<File> writeCounter(String counter) async {
    final file = await File('configuration.txt');

    // Write the file
    return file.writeAsString('$counter');
  }

  void _loadData() async {
    final _loadedData = await rootBundle.loadString('configuration.txt');
    setState(() {
      dataconf = _loadedData;
    });
    endpoint.text = dataconf!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoggedIn
          ? ProfilePage()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: _headerHeight,
                    child: HeaderWidget(
                        _headerHeight,
                        true,
                        Icons
                            .login_rounded), //let's create a common header widget
                  ),
                  SafeArea(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        margin: EdgeInsets.fromLTRB(
                            20, 10, 20, 10), // This will be the login form
                        child: Column(
                          children: [
                            SizedBox(height: 30.0),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextField(
                                        controller: mailController,
                                        decoration: ThemeHelper()
                                            .textInputDecoration('Nome Utente',
                                                "Scrivi l'username"),
                                      ),
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: 30.0),
                                    Container(
                                      child: TextField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: ThemeHelper()
                                            .textInputDecoration('Password',
                                                "Scrivi la password"),
                                      ),
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: 15.0),
                                    Container(
                                      child: TextFormField(
                                        controller: endpoint,
                                        decoration: ThemeHelper()
                                            .textInputDecoration('Endpoint',
                                                "Scrivi l'endpoint"),

                                        //initialValue: "premiosrl",
                                      ),
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: 15.0),
                                    Container(
                                      decoration: ThemeHelper()
                                          .buttonBoxDecoration(context),
                                      child: ElevatedButton(
                                        style: ThemeHelper().buttonStyle(),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Text(
                                            'Entra'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        /*onPressed: () {
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
                                  },*/
                                        onPressed: _isLoading ? null : _login,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Errore'),
            content: Text('Endpoint vuoto'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Chiudi',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showErrorEndpointDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Errore'),
            content: Text('Inserire l\'endpoint corretto'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Chiudi',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showUserErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Errore'),
            content: Text('Username / Password Non Corrette'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Chiudi',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': mailController.text,
      'password': passwordController.text,
      'endpoint': endpoint.text
    };

    if (endpoint.text == "") {
      _showDialog(context);
    } else {
      var res;
      try {
        res = await CallApi().postData(data, 'login');
      } catch (e) {
        _showErrorEndpointDialog(context);
      }

      var body = json.decode(res.body);

      var Endpoint = data['endpoint'];
      if (body['message'] == "Credenziali non valide") {
        _showUserErrorDialog(context);
      } else if (body['user'] != "") {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['accessToken']);
        localStorage.setString('user', json.encode(body['user']));
        localStorage.setString('endpoint', Endpoint!);
        writeCounter(Endpoint);

        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ProfilePage()));
      } else {
        _showDialog(context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
