import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qualifica_group/common/theme_helper.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:connectivity/connectivity.dart';
import 'profile_page.dart';
import 'widgets/header_widget.dart';
import 'package:intl/intl.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  List<Color> _colorCollection = <Color>[];
  String? _networkStatusMsg;
  var userData;
  final Connectivity _internetConnectivity = new Connectivity();

  @override
  void initState() {
    _getUserInfo();
    userData = _getTasks();
    print(userData);
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
    print(userData);
  }

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token;
  }

  Future<http.Response> _getTasks() async {
    var fullUrl = 'https://italiaqualificagroup.org/api/task';

    return await http.get(Uri.parse(fullUrl), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ' + await getToken()
    });
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(
                    _headerHeight, true, Icons.privacy_tip_outlined),
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
                              child: Container(
                                  child: SfCalendar(
                                view: CalendarView.week,
                                initialDisplayDate:
                                    DateTime(2022, 1, 11, 0, 0, 0),
                                dataSource: MeetingDataSource(snapshot.data),
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

  Future<List<Meeting>> getDataFromWeb() async {
    var data = await _getTasks();

    var jsonData = json.decode(data.body);

    final List<Meeting> appointmentData = [];
    final Random random = new Random();
    for (var data in jsonData['tasks']) {
      print(data['datatask'].split('-')[2]);
      Meeting meetingData = Meeting(
          eventName: data['title'],
          from: _convertDateFromString(data['datatask'].split('-')[2] +
              '-' +
              data['datatask'].split('-')[1] +
              '-' +
              data['datatask'].split('-')[0] +
              'T' +
              data['timetask']),
          to: _convertDateFromString(data['datatask'].split('-')[2] +
              '-' +
              data['datatask'].split('-')[1] +
              '-' +
              data['datatask'].split('-')[0] +
              'T' +
              data['timetaskend']),
          background: _colorCollection[random.nextInt(9)],
          allDay: false);
      appointmentData.add(meetingData);
    }
    return appointmentData;
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
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].allDay;
  }
}

class Meeting {
  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.allDay = false});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? allDay;
}

class Task {
  /*Task({
        this.id,
        this.customerId,
        this.opportunityId,
        this.orderId,
        this.ordermilestoneId,
        this.typetask,
        this.title,
        this.description,
        this.datatask,
        this.timetask,
        this.siteId,
        this.endtask,
        this.timetaskend,
        this.status,
        this.assignedBy,
        this.utente,
        this.name,
        this.lastName,
        this.assignedId,
        this.assignedTo,
        this.companyName,
        this.address,
        this.city,
        this.phone,
    });

    int id;
    int customerId;
    dynamic opportunityId;
    int orderId;
    dynamic ordermilestoneId;
    String typetask;
    String title;
    dynamic description;
    String datatask;
    String timetask;
    int siteId;
    dynamic endtask;
    String timetaskend;
    int status;
    int assignedBy;
    int utente;
    String name;
    String lastName;
    int assignedId;
    int assignedTo;
    String companyName;
    String address;
    String city;
    String phone;*/

  /*factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        customerId: json["customer_id"],
        opportunityId: json["opportunity_id"],
        orderId: json["order_id"],
        ordermilestoneId: json["ordermilestone_id"],
        typetask: json["typetask"],
        title: json["title"],
        description: json["description"],
        datatask: json["datatask"],
        timetask: json["timetask"],
        siteId: json["site_id"],
        endtask: json["endtask"],
        timetaskend: json["timetaskend"],
        status: json["status"],
        assignedBy: json["assigned_by"],
        utente: json["utente"],
        name: json["name"],
        lastName: json["last_name"],
        assignedId: json["assigned_id"],
        assignedTo: json["assigned_to"],
        companyName: json["company_name"],
        address: json["address"],
        city: json["city"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "opportunity_id": opportunityId,
        "order_id": orderId,
        "ordermilestone_id": ordermilestoneId,
        "typetask": typetask,
        "title": title,
        "description": description,
        "datatask": datatask,
        "timetask": timetask,
        "site_id": siteId,
        "endtask": endtask,
        "timetaskend": timetaskend,
        "status": status,
        "assigned_by": assignedBy,
        "utente": utente,
        "name": name,
        "last_name": lastName,
        "assigned_id": assignedId,
        "assigned_to": assignedTo,
        "company_name": companyName,
        "address": address,
        "city": city,
        "phone": phone,
    };*/
}
