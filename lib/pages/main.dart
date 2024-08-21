import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  CalendarController? _calendarController;
  List<Appointment> _appointments = [];

  @override
  void initState() {
    _calendarController = CalendarController();
    _loadAppointments();
    super.initState();
  }

  Future<void> _loadAppointments() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/appointments.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> data = jsonDecode(contents);
        setState(() {
          _appointments =
              data.map((json) => Appointment.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print("Couldn't read file: $e");
    }
  }

  // Future<void> _loadAppointments() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File('${directory.path}/appointments.json');
  //     if (await file.exists()) {
  //       final contents = await file.readAsString();
  //       final List<dynamic> data = jsonDecode(contents);
  //       setState(() {
  //         _appointments =
  //             data.map((json) => Appointment.fromJson(json)).toList();
  //       });
  //       // Print appointments
  //       _appointments.forEach((appointment) {
  //         print(
  //             "Appointment: ${appointment.subject}, Start: ${appointment.startTime}, End: ${appointment.endTime}");
  //       });
  //     }
  //   } catch (e) {
  //     print("Couldn't read file: $e");
  //   }
  // }

  Future<void> _saveAppointments() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/appointments.json');
    final data =
        _appointments.map((appointment) => appointment.toJson()).toList();
    await file.writeAsString(jsonEncode(data));
  }

  void _addAppointment() {
    final now = DateTime.now();

    if (_appointments.length >= 2) {
      print("Cannot add more than 2 appointments");
      return;
    }

    final newAppointment = Appointment(
      startTime: now,
      endTime: now,
      subject: _appointments.isEmpty ? 'Datang' : 'Pulang',
      color: _appointments.isEmpty ? Colors.green : Colors.red,
    );
    setState(() {
      _appointments.add(newAppointment);
    });
    _saveAppointments();

    // Print appointment creation time
    print(
        "Appointment created at: ${DateTime.now().hour}:${DateTime.now().minute}");
  }

  void _resetAppointments() async {
    setState(() {
      _appointments.clear();
    });
    _saveAppointments();
  }

  Future<void> _exportToExcel() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final path = "${directory.path}/appointments.xlsx";
      final workbook = xlsio.Workbook();
      final sheet = workbook.worksheets[0];

      // Add header
      sheet.getRangeByName('A1').setText('Tanggal');
      sheet.getRangeByName('B1').setText('Datang');
      sheet.getRangeByName('C1').setText('Pulang');

      // Add appointment data
      var lastDate = _appointments[0].startTime;
      for (int i = 0; i < _appointments.length; i++) {
        final appointment = _appointments[i];
        final currentDate = appointment.startTime;
        sheet
            .getRangeByName('A${i + 2}')
            .setText(formatter.format(appointment.startTime));
        if (lastDate == currentDate) {
          sheet.getRangeByName('B${i + 2}').setText(
              "${appointment.startTime.hour.toString().padLeft(2, '0')}:${appointment.startTime.minute.toString().padLeft(2, '0')}");
          sheet.getRangeByName('C${i + 2}').setText(
              "${_appointments[i + 1].startTime.hour.toString().padLeft(2, '0')}:${_appointments[i + 1].startTime.minute.toString().padLeft(2, '0')}");
          i++;
        }
        lastDate = currentDate;
      }
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      // Show the popup dialog
      _showDownloadDialog(context, path);
    } else {
      print("Could not access external storage directory");
    }
  }

  void _showDownloadDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Download Successful"),
        content: Text("The Excel file has been saved at: $path"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              OpenFile.open(path);
            },
            child: Text("Open"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour > 3 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final selectedDate = _calendarController?.selectedDate ?? DateTime.now();
    final selectedAppointments = _appointments.where((appointment) {
      return appointment.startTime.year == selectedDate.year &&
          appointment.startTime.month == selectedDate.month &&
          appointment.startTime.day == selectedDate.day;
    }).toList();

    return Container(
      color: const Color.fromRGBO(255, 110, 0, 1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(255, 110, 0, 1),
            title: Text(
              greeting(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset('images/download_icon.svg'),
                onPressed: _exportToExcel,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                color: Colors.white,
                onPressed: _resetAppointments,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: [
                SfCalendar(
                  onSelectionChanged: (calendarSelectionDetails) {
                    setState(() {});
                  },
                  dataSource: AppointmentDataSource(_appointments),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayCount: 2,
                    monthCellStyle: MonthCellStyle(
                      textStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  headerStyle: const CalendarHeaderStyle(
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showTodayButton: true,
                  viewHeaderStyle: const ViewHeaderStyle(
                    dayTextStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  showDatePickerButton: true,
                  headerHeight: 60,
                  showNavigationArrow: true,
                  view: CalendarView.month,
                  todayHighlightColor: const Color.fromRGBO(255, 110, 0, 1),
                  cellBorderColor: Colors.transparent,
                  maxDate: DateTime.now(),
                  minDate: DateTime(2020, 01, 01),
                  controller: _calendarController,
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Datang',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          selectedAppointments.isNotEmpty
                              ? "${selectedAppointments[0].startTime.hour.toString().padLeft(2, '0')}:${selectedAppointments[0].startTime.minute.toString().padLeft(2, '0')}"
                              : "--:--",
                          style: const TextStyle(
                            fontSize: 40,
                            color: Color.fromRGBO(255, 110, 0, 1),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pulang',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          selectedAppointments.length > 1
                              ? "${selectedAppointments[1].startTime.hour.toString().padLeft(2, '0')}:${selectedAppointments[1].startTime.minute.toString().padLeft(2, '0')}"
                              : "--:--",
                          style: const TextStyle(
                            fontSize: 40,
                            color: Color.fromRGBO(255, 110, 0, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _addAppointment,
                  icon: Container(
                    alignment: Alignment.center,
                    width: 361,
                    height: 53,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 110, 0, 1),
                        borderRadius: BorderRadius.circular(14)),
                    child: const Text(
                      'Presensi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class Appointment {
  DateTime startTime;
  DateTime endTime;
  String subject;
  Color color;

  Appointment(
      {required this.startTime,
      required this.endTime,
      required this.subject,
      required this.color});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      subject: json['subject'],
      color: Color(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'subject': subject,
      'color': color.value,
    };
  }
}
