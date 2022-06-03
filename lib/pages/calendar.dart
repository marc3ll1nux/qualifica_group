import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qualifica_group/pages/qr_code.dart';
import 'login_page.dart';
import 'widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qualifica_group/api/api.dart';
import 'package:qualifica_group/syncfusion/define_meeting.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
        const Locale('he'),
        const Locale('ru'),
        const Locale('fr', 'BE'),
        const Locale('fr', 'CA'),
        const Locale('ja'),
        const Locale('de'),
        const Locale('hi'),
        const Locale('ar'),
      ],
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      home: CalendarioApp(),
    );
  }
}

class CalendarioApp extends StatefulWidget {
  const CalendarioApp({Key? key}) : super(key: key);

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioApp> {
  final _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  var userData;

  List<Color> _colorCollection = <Color>[];
  String? _networkStatusMsg;
  final Connectivity _internetConnectivity = new Connectivity();

  @override
  void initState() {
    _getUserInfo();
    _initializeEventColor();
    _checkNetworkStatus();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  DateTime _convertDateFromString(String date) {
    return DateTime.parse(date);
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  void _checkNetworkStatus() {
    _internetConnectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _networkStatusMsg = result.toString();
        if (_networkStatusMsg == "ConnectivityResult.mobile") {
          _networkStatusMsg =
              "You are connected to mobile network, loading calendar data ....";
        } else if (_networkStatusMsg == "ConnectivityResult.wifi") {
          _networkStatusMsg =
              "You are connected to wifi network, loading calendar data ....";
        } else {
          _networkStatusMsg =
              "Internet connection may not be available. Connect to another network";
        }
      });
    });
  }

  Future<List<Meeting>> getDataFromWeb() async {
    var resTask = await CallApi().getTasks('task');

    var jsonData = json.decode(resTask.body);

    final List<Meeting> appointmentData = [];
    final Random random = new Random();
    var jsonData1 = jsonData['tasks'];

    for (var data in jsonData1) {
      var arr = data['datatask'].split('-');

      Meeting meetingData = Meeting(
          eventName: data['title'],
          from: _convertDateFromString(
            arr[2] + "-" + arr[1] + "-" + arr[0] + "T" + data['timetask'],
          ),
          to: _convertDateFromString(
            arr[2] + "-" + arr[1] + "-" + arr[0] + "T" + data['timetaskend'],
          ),
          background: _colorCollection[random.nextInt(9)],
          allDay: false);
      appointmentData.add(meetingData);
    }
    return appointmentData;
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Calendario",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                ])),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(
                top: 16,
                right: 16,
              ),
              child: Stack(
                children: <Widget>[
                  Icon(Icons.notifications),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                  0.0,
                  1.0
                ],
                    colors: [
                  Theme.of(context).primaryColor.withOpacity(0.2),
                  Theme.of(context).accentColor.withOpacity(0.5),
                ])),
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).accentColor,
                      ],
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      userData != null
                          ? '${userData['name']} ${userData['last_name']}'
                          : '',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    size: _drawerIconSize,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Calendario',
                    style: TextStyle(
                        fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarioApp()),
                    );
                  },
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.verified_user_sharp,
                    size: _drawerIconSize,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Monitoraggio',
                    style: TextStyle(
                        fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarioApp()),
                    );
                  },
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.verified_user_sharp,
                    size: _drawerIconSize,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Rapportino',
                    style: TextStyle(
                        fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QrCodePage()),
                    );
                  },
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    size: _drawerIconSize,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    //  SystemNavigator.pop();
                    logout();
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.calendar_today),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calendario',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      FutureBuilder(
                        future: getDataFromWeb(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data != null) {
                            return SafeArea(
                              child: Localizations.override(
                                  context: context,
                                  locale: Locale('it'),
                                  child: SfCalendar(
                                    view: CalendarView.week,
                                    initialDisplayDate:
                                        DateTime(2022, 1, 14, 7, 0, 0),
                                    dataSource:
                                        MeetingDataSource(snapshot.data),
                                  )),
                            );
                          } else {
                            return Container(
                              child: Center(
                                child: Text('$_networkStatusMsg'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void logout() async {
    // logout from the server ...
    var res = await CallApi().getData('logout');
    var body = json.decode(res.body);
    if (body['user'] != "") {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}
