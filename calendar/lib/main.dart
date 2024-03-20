import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'about_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiggyBankM',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PiggyBankM'),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
      body: MyCalendar(),
    );
  }
}

class MyCalendar extends StatefulWidget {
  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  String _selectedAmount = '';
  List<Appointment> _appointments = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCalendar(
          view: CalendarView.month,
          dataSource: _getCalendarDataSource(),
          monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            showAgenda: true,
          ),
          onTap: _handleCalendarTap,
          appointmentBuilder: (BuildContext context, CalendarAppointmentDetails calendarAppointmentDetails) {
            final appointment = calendarAppointmentDetails.appointments.first;
            return Container(
              decoration: BoxDecoration(
                color: appointment.color,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Text('${appointment.subject} '),
                    Text('RUB'),
                  ],
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              onPressed: () {
                _showDialog(context);
              },
              child: Icon(Icons.add, color: Colors.purple),
            ),
          ),
        ),
      ],
    );
  }

  _showDialog(BuildContext context) {
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Distribution by day'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: startDateController,
                      decoration: InputDecoration(labelText: 'Start date'),
                      onTap: () async {
                        _selectDate(context, startDateController);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,2}\.\d{0,2}\.\d{0,4}$')),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: endDateController,
                      decoration: InputDecoration(labelText: 'End date'),
                      onTap: () async {
                        _selectDate(context, endDateController);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,2}\.\d{0,2}\.\d{0,4}$')),
                      ],
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'The amount of money'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                String startDate = startDateController.text;
                String endDate = endDateController.text;
                String amount = amountController.text;
                setState(() {
                  _selectedAmount = amount;
                });
                _distributeAmount(startDate, endDate, amount);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
      controller.text = formattedDate;
    }
  }

  _DataSource _getCalendarDataSource() {
    return _DataSource(_appointments);
  }

  void _handleCalendarTap(CalendarTapDetails details) {
    if (details.appointments != null && details.targetElement == CalendarElement.appointment) {
      final appointment = details.appointments![0];
      _showAppointmentInfo(context, appointment);
    }
  }

  void _showAppointmentInfo(BuildContext context, Appointment appointment) {
    bool isDone = appointment.color == Colors.green;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Money Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Amount: ${appointment.subject} '),
                  Text('RUB'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                  SizedBox(width: 8),
                  if (!isDone)
                    ElevatedButton(
                      onPressed: () {
                        _markAppointmentAsDone(appointment);
                        Navigator.of(context).pop();
                      },
                      child: Text('Done'),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _markAppointmentAsDone(Appointment appointment) {
    setState(() {
      appointment.color = Colors.green;
    });
  }

  void _distributeAmount(String startDate, String endDate, String amount) {
    List<Appointment> newAppointments = [];
    DateTime startDateTime = DateFormat('dd.MM.yyyy').parse(startDate);
    DateTime endDateTime = DateFormat('dd.MM.yyyy').parse(endDate);
    int numberOfDays = endDateTime.difference(startDateTime).inDays + 1;
    double distributedAmount = double.parse(amount) / numberOfDays;

    for (int i = 0; i < numberOfDays; i++) {
      DateTime currentDate = startDateTime.add(Duration(days: i));
      newAppointments.add(Appointment(
        startTime: currentDate,
        endTime: currentDate.add(Duration(hours: 2)),
        subject: '$distributedAmount',
        color: Colors.red,
      ));
    }

    setState(() {
      _appointments.addAll(newAppointments);
    });
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
