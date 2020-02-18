import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart' as csv;
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  List<List<dynamic>> rowsAsListOfValues = [];

  Map<DateTime, List> _events;
  Map<DateTime, List> _holidays;
  List _selectedEvents;

  CalendarController _calendarController;

  @override
  void initState() {
    _isLoading = true;
    _loadAsset();

    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<void> _loadAsset() async {
    final csvString =
        await rootBundle.loadString('assets/schedule/108_schedule.csv');
    rowsAsListOfValues = csv.CsvToListConverter().convert(
      csvString,
      shouldParseNumbers: false,
    );

    _events = {};
    _holidays = {};

    rowsAsListOfValues.forEach((row) {
      final DateTime date = DateTime.parse(row[0]);
      final String event = row[1];
      final bool isHoliday = row[2] == '1';
      if (isHoliday) {
        _holidays.update(
          date,
          (oldEventList) {
            var temp = oldEventList;
            temp.add(event);
            return temp;
          },
          ifAbsent: () => [event],
        );
      }
      _events.update(
        date,
        (oldEventList) {
          var temp = oldEventList;
          temp.add(event);
          return temp;
        },
        ifAbsent: () => [event],
      );
    });

    final _tempDateTime = DateTime.now();
    final _selectedDay =
        DateTime(_tempDateTime.year, _tempDateTime.month, _tempDateTime.day);

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    setState(() {
      _isLoading = false;
    });
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('行事曆'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTableCalendar(),
                const SizedBox(height: 8.0),
                Expanded(child: _buildEventList()),
              ],
            ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      locale: 'zh_Hant_TW',
      events: _events,
      holidays: _holidays,
      availableCalendarFormats: const {
        CalendarFormat.month: '全月',
        CalendarFormat.twoWeeks: '雙週',
        CalendarFormat.week: '單週',
      },
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: true,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.blue[400], fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(7.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(event.toString()),
                ),
              ))
          .toList(),
    );
  }
}
