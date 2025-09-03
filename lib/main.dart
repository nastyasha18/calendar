import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ru_RU', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'calendar',
      debugShowCheckedModeBanner: false,
      home: Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _currentMonth = DateTime.now();

  PageController _pageController =
      PageController(initialPage: DateTime.now().month);

  List years = [];

  Widget buildWeekDay(String day) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        day,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildWeeks() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildWeekDay('Пн'),
          buildWeekDay('Вт'),
          buildWeekDay('Ср'),
          buildWeekDay('Чт'),
          buildWeekDay('Пт'),
          buildWeekDay('Сб'),
          buildWeekDay('Вс'),
        ],
      ),
    );
  }

  Color getColor() {
    if (_currentMonth.year == DateTime.now().year &&
        DateTime.now().month == _currentMonth.month) {
      return const Color.fromARGB(255, 58, 151, 244);
    } else
      return Colors.black;
  }

  Widget buildHeader() {
    bool isLastMonthOfYear = _currentMonth.month == 12;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                if (_pageController.page! > 1) {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 10),
                    curve: Curves.easeInOut,
                  );
                } else {
                  if (years.contains(_currentMonth.year - 1)) {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month - 1, 1);
                      _pageController.jumpToPage(12);
                    });
                  }
                }
              },
              icon: Icon(Icons.arrow_back)),
          Text(
            '${DateFormat('MMMM', 'ru_RU').format(_currentMonth)}',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: getColor()),
          ),
          DropdownButton<int>(
            value: _currentMonth.year,
            onChanged: (int? year) {
              if (year != null) {
                setState(() {
                  _currentMonth = DateTime(year, _currentMonth.month, 1);
                  _pageController.jumpToPage(_currentMonth.month);
                });
              }
            },
            items: [
              for (int year = DateTime.now().year - 5;
                  year <= DateTime.now().year + 5;
                  year++)
                DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
            ],
          ),
          IconButton(
              onPressed: () {
                if (!isLastMonthOfYear) {
                  setState(() {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 10),
                      curve: Curves.easeInOut,
                    );
                  });
                } else {
                  setState(() {
                    if (years.contains(_currentMonth.year + 1)) {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month + 1, 1);
                      _pageController.jumpToPage(1);
                    }
                  });
                }
              },
              icon: Icon(Icons.arrow_forward))
        ],
      ),
    );
  }

  BoxDecoration wrapDay(bool isActive) {
    if (isActive)
      return BoxDecoration(shape: BoxShape.circle, color: Colors.blue);
    else {
      return BoxDecoration();
    }
  }

  void getNowMonth() {
    setState(() {
      _currentMonth = DateTime.now();
      _pageController.jumpToPage(DateTime.now().month);  
    });
    
  }

  Widget buildCalendar(DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    DateTime lastDayOfPreviousMonth =
        firstDayOfMonth.subtract(Duration(days: 1));
    int daysInPreviousMonth = lastDayOfPreviousMonth.day;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: daysInMonth + weekdayOfFirstDay - 1,
      itemBuilder: (context, index) {
        if (index < weekdayOfFirstDay - 1) {
          int previousMonthDay =
              daysInPreviousMonth - (weekdayOfFirstDay - index) + 2;
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide.none,
                left: BorderSide(width: 1.0, color: Colors.grey),
                right: BorderSide(width: 1.0, color: Colors.grey),
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              previousMonthDay.toString(),
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          DateTime date =
              DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);
          String text = date.day.toString();
          bool isActiveDay = false;
          if (date.day == DateTime.now().day &&
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year) {
            isActiveDay = true;
          }

          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide.none,
                left: BorderSide(width: 1.0, color: Colors.grey),
                right: BorderSide(width: 1.0, color: Colors.grey),
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: wrapDay(isActiveDay),
              child: Text(
                text,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    for (int year = DateTime.now().year - 5;
        year <= DateTime.now().year + 5;
        year++) {
      years.add(year);
    }
    print(years);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Календарь'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: getNowMonth, child: Icon(Icons.calendar_month, color: Colors.white,), backgroundColor: Colors.blue,),
      body: Column(
        children: [
          buildHeader(),
          buildWeeks(),
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentMonth = DateTime(_currentMonth.year, index, 1);
                });
              },
              itemBuilder: (context, pageIndex) {
                DateTime month = DateTime(_currentMonth.year, pageIndex, 1);
                return buildCalendar(month);
              },
            ),
          ),
        ],
      ),
    );
  }
}
