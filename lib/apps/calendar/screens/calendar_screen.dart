import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart' as csv;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List weekday2CH = ['', '一', '二', '三', '四', '五', '六', '日'];

enum CalenderMode {
  calendar,
  list,
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  CalenderMode _mode = CalenderMode.calendar;
  List<List<dynamic>> rowsAsListOfValues = [];

  Map<DateTime, List> _events = {};
  Map<DateTime, List> _holidays = {};
  List _selectedEvents = [];
  DateTime _selectedDay = DateTime(2020);

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
    _selectedDay =
        DateTime(_tempDateTime.year, _tempDateTime.month, _tempDateTime.day);

    _calendarController = CalendarController();

    //////////////////////////////////////////// startup mode

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('calenderStartupMode') == null) {
      await prefs.setInt('calenderStartupMode', 0);
      _mode = CalenderMode.calendar;
    } else if (prefs.getInt('calenderStartupMode') == 0) {
      _mode = CalenderMode.calendar;
    } else if (prefs.getInt('calenderStartupMode') == 1) {
      _mode = CalenderMode.list;
    }

    ////////////////////////////////////////////

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedEvents = _events[_selectedDay] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text('行事曆'),
        centerTitle: true,
        actions: <Widget>[
          _modeMenuButton(),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _mode == CalenderMode.list
              ? _buildCalendarList()
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

  Widget _buildCalendarList() {
    final daysList = _events.entries
        .map((entry) => [entry.key, entry.value])
        .toList(); // List<List[DateTime day, List events]>
    int initIndex = daysList.length - 1;
    int len = daysList.length;
    for (int i = 0; i < len; i++) {
      if ((daysList[i][0] as DateTime)
          .isAfter(_selectedDay.subtract(Duration(days: 1)))) {
        initIndex = i;
        break;
      }
    }

    return ScrollablePositionedList.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      initialScrollIndex: initIndex,
      itemCount: daysList.length,
      separatorBuilder: (_, __) => Divider(thickness: 1.0, height: 1.0),
      itemBuilder: (context, index) {
        final DateTime datetime = daysList[index][0];
        final String date = DateFormat('MM / dd').format(datetime) +
            ' (' +
            weekday2CH[datetime.weekday] +
            ')';

        final List events = daysList[index][1];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  date,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Expanded(
                flex: 2,
                child: _eventListWidget(events),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _eventListWidget(List events) {
    final int len = events.length;
    int i = 0;
    List<Widget> temp = [];
    events.forEach((event) {
      temp.add(
        Text(
          event,
          style: TextStyle(fontSize: 18.0),
        ),
      );
      if (++i < len) {
        temp.add(
          Divider(thickness: 1.0, height: 18.0),
        );
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: temp,
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      initialSelectedDay: _selectedDay,
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
      onDaySelected: (DateTime day, List events) {
        setState(() {
          _selectedDay = DateTime(day.year, day.month, day.day);
        });
      },
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

  /////////////////////////////////////////////////////////////////////

  PopupMenuButton<CalenderMode> _modeMenuButton() {
    return PopupMenuButton<CalenderMode>(
      onSelected: (CalenderMode result) {
        setState(() {
          _mode = result;
        });
      },
      icon: Icon(Icons.more_vert),
      tooltip: '切換模式',
      itemBuilder: (BuildContext context) => <PopupMenuEntry<CalenderMode>>[
        if (_mode != CalenderMode.list)
          const PopupMenuItem<CalenderMode>(
            value: CalenderMode.list,
            child: Text('切換至列表模式'),
          ),
        if (_mode != CalenderMode.calendar)
          const PopupMenuItem<CalenderMode>(
            value: CalenderMode.calendar,
            child: Text('切換至月曆模式'),
          ),
      ],
    );
  }
}
