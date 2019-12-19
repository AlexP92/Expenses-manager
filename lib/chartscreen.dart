import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expenseprov.dart';
import "package:syncfusion_flutter_charts/charts.dart";

class ChartScreen extends StatefulWidget {
  static final routeName = '/chartscreen';

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String ddyear;
  String ddmonth;
  String ddrecent;
  String ddcat;
  var bool = true;

  List yearlist=['All', '2019', '2018', '2017'];

  List<Map<String, dynamic>> explist;
  List<Map<String, dynamic>> auxlist;

  var isnit = true;

  String smonth(month) {
    switch (month) {
      case "January":
        return "1";
        break;
      case "February":
        return "2";
        break;
      case "March":
        return "3";
        break;
      case "April":
        return "4";
        break;
      case "May":
        return "5";
        break;
      case "June":
        return "6";
        break;
      case "July":
        return "7";
        break;
      case "August":
        return "8";
        break;
      case "September":
        return "9";
        break;
      case "October":
        return "10";
        break;
      case "November":
        return "11";
        break;
      case "December":
        return "12";
        break;
      default:
        return null;
    }
  }

  void function(String cat, String month, String year) {
    bool = true;
    auxlist = [];
    ddrecent = null;

    if (cat == null) cat = "All";
    if (month == null)
      month = "All";
    else
      month = smonth(month);
    if (year == null) year = "All";

    // print("!!! $cat");
    // print("!!! $month");
    // print("!!! $year");

    auxlist = explist.where((item) {
      if (item['cat'] == cat &&
          item['month'] == month &&
          item['year'] == year) {
        return item['cat'] == cat &&
            item['month'] == month &&
            item['year'] == year;
      } else if (cat == "All" && item['month'] == month && item['year'] == year)
        return item['month'] == month && item['year'] == year;
      else if (cat == "All" && month == "All" && item['year'] == year)
        return item['year'] == year;
      else if (cat == "All" && item['month'] == month && year == "All")
        return item['month'] == month;
      else if (item['cat'] == cat && item['month'] == month && year == "All")
        return item['cat'] == cat && item['month'] == month;
      else if (item['cat'] == cat && month == "All" && year == "All") {
        return item['cat'] == cat;
      } else if (item['cat'] == cat && month == "All" && item['year'] == year)
        return item['cat'] == cat && item['year'] == year;
      else if (cat == "All" && month == "All" && year == "All")
        return true;
      else
        return false;
    }).toList();

    setState(() {
      shownChart(auxlist, cat, month, year);
    });
  }

  Widget shownChart(List auxlist, String cat, String month, String year) {
    if (cat == null) cat = "All";
    if (month == null)
      month = "All";
    else
      month = smonth(month);
    if (year == null) year = "All";

    List<Cartesian> c = [];

    if (year == "All") {
      c = [];
      for (int i = 0; i < auxlist.length; i++) {
        var bool = true;
        for (int j = 0; j < c.length; j++)
          if (c[j].x == auxlist[i]['year'].toString()) {
            c[j].y = c[j].y + auxlist[i]['amount'];
            bool = false;
          }

        if (bool)
          c.add(Cartesian(auxlist[i]['year'].toString(), auxlist[i]['amount']));
      }
      c.sort((a, b) {
        var r = a.x.compareTo(b.x);
        if (r != 0) return r;
        return a.x.compareTo(b.x);
      });
      if (c[0].x == "0") c.removeAt(0);
    } else {
      c = [
        Cartesian("1", 0),
        Cartesian("2", 0),
        Cartesian("3", 0),
        Cartesian("4", 0),
        Cartesian("5", 0),
        Cartesian("6", 0),
        Cartesian("7", 0),
        Cartesian("8", 0),
        Cartesian("9", 0),
        Cartesian("10", 0),
        Cartesian("11", 0),
        Cartesian("12", 0),
      ];
      for (int i = 0; i < auxlist.length; i++) {
        if (auxlist[i]['year'] == year)
          for (int j = 0; j < c.length; j++)
            if (c[j].x == auxlist[i]['month'].toString()) {
              c[j].y = c[j].y + auxlist[i]['amount'];
            }
      }
    }

    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        legend: Legend(
            title: ddyear == "All" || ddyear == null
                ? LegendTitle(text: "Year")
                : LegendTitle(text: "Month"),
            position: LegendPosition.bottom,
            isVisible: true,
            height: "0"),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Container(
                decoration: BoxDecoration(
                    color: Colors.black54.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                child: Text('RON : ${point.y.toStringAsFixed(2)}'));
          },
          duration: 5000,
        ),
        series: <ChartSeries<Cartesian, String>>[
          LineSeries<Cartesian, String>(
              dataSource: <Cartesian>[...c.toList()],
              xValueMapper: (Cartesian p, _) => p.x,
              yValueMapper: (Cartesian p, _) => p.y,
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false))
        ]);
  }

  Widget shownChart2(List aux, String ddrecent) {
    List<Cartesian> c = [];
    if (ddrecent == "Last week") {
      c = [];
      for (int i = 7; i >= 0; i--) c.add(Cartesian(i.toString(), 0));
      for (int i = 0; i < auxlist.length; i++) {
        String m = auxlist[i]['month'].toString();
        String d = auxlist[i]['day'].toString();
        String y = auxlist[i]['year'].toString();
        if (m.length == 1) m = "0" + m;
        if (d.length == 1) d = "0" + d;
        if (y.length == 1) y = "000" + y;
        String s = y + "-" + m + '-' + d;
        DateTime t = DateTime.parse(s);
        for (int j = 0; j < c.length; j++) {
          int x = int.parse(c[j].x);

          if (DateTime.now().difference(t).inDays == x)
            c[j].y += auxlist[i]['amount'];
        }
      }
      c[7].x = "Today";
    }
    if (ddrecent == "Last 2 weeks") {
      c = [];
      for (int i = 14; i >= 0; i--) c.add(Cartesian(i.toString(), 0));
      for (int i = 0; i < auxlist.length; i++) {
        String m = auxlist[i]['month'].toString();
        String d = auxlist[i]['day'].toString();
        String y = auxlist[i]['year'].toString();
        if (m.length == 1) m = "0" + m;
        if (d.length == 1) d = "0" + d;
        if (y.length == 1) y = "000" + y;
        String s = y + "-" + m + '-' + d;
        DateTime t = DateTime.parse(s);
        for (int j = 0; j < c.length; j++) {
          int x = int.parse(c[j].x);

          if (DateTime.now().difference(t).inDays == x)
            c[j].y += auxlist[i]['amount'];
        }
      }
      c[14].x = "Today";
    }
    if (ddrecent == "Last month") {
      c = [];
      for (int i = 30; i >= 0; i--) c.add(Cartesian(i.toString(), 0));
      for (int i = 0; i < auxlist.length; i++) {
        String m = auxlist[i]['month'].toString();
        String d = auxlist[i]['day'].toString();
        String y = auxlist[i]['year'].toString();
        if (m.length == 1) m = "0" + m;
        if (d.length == 1) d = "0" + d;
        if (y.length == 1) y = "000" + y;
        String s = y + "-" + m + '-' + d;
        DateTime t = DateTime.parse(s);
        for (int j = 0; j < c.length; j++) {
          int x = int.parse(c[j].x);

          if (DateTime.now().difference(t).inDays == x)
            c[j].y += auxlist[i]['amount'];
        }
      }
      c[30].x = "Today";
    }
    if (ddrecent == "Last 4 months") {
      c = [];
      for (int i = 4; i >= 0; i--) c.add(Cartesian(i.toString(), 0));
      for (int i = 0; i < auxlist.length; i++) {
        String m = auxlist[i]['month'].toString();
        String d = auxlist[i]['day'].toString();
        String y = auxlist[i]['year'].toString();
        if (m.length == 1) m = "0" + m;
        if (d.length == 1) d = "0" + d;
        if (y.length == 1) y = "000" + y;
        String s = y + "-" + m + '-' + d;
        DateTime t = DateTime.parse(s);
        for (int j = 0; j < c.length; j++) {
          int x = int.parse(c[j].x);

          if (DateTime.now().difference(t).inDays >= x * 30 &&
              DateTime.now().difference(t).inDays < (x + 1) * 30)
            c[j].y += auxlist[i]['amount'];
        }
      }
      c[4].x = "This month";
    }
    if (ddrecent == "Last year") {
      c = [];
      for (int i = 12; i >= 0; i--) c.add(Cartesian(i.toString(), 0));
      for (int i = 0; i < auxlist.length; i++) {
        String m = auxlist[i]['month'].toString();
        String d = auxlist[i]['day'].toString();
        String y = auxlist[i]['year'].toString();
        if (m.length == 1) m = "0" + m;
        if (d.length == 1) d = "0" + d;
        if (y.length == 1) y = "000" + y;
        String s = y + "-" + m + '-' + d;
        DateTime t = DateTime.parse(s);
        for (int j = 0; j < c.length; j++) {
          int x = int.parse(c[j].x);

          if (DateTime.now().difference(t).inDays >= x * 30 &&
              DateTime.now().difference(t).inDays < (x + 1) * 30)
            c[j].y += auxlist[i]['amount'];
        }
      }
      c[12].x = "This month";
    }

    return SfCartesianChart(

        primaryXAxis: CategoryAxis(
        ),
        legend: Legend(
            title: ddrecent == "Last 4 months" || ddrecent == "Last year"
                ? LegendTitle(text: "Months ago")
                : LegendTitle(text: "Days ago"),
            position: LegendPosition.bottom,
            isVisible: true,
            height: "0"),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Container(
                decoration: BoxDecoration(
                    color: Colors.black54.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                child: Text('RON : ${point.y.toStringAsFixed(2)}'));
          },
          duration: 5000,
        ),
        series: <ChartSeries<Cartesian, String>>[
          LineSeries<Cartesian, String>(
            
              dataSource: <Cartesian>[...c.toList()],
              xValueMapper: (Cartesian p, _) => p.x,
              yValueMapper: (Cartesian p, _) => p.y,
              enableTooltip: true,
              dataLabelSettings: DataLabelSettings(isVisible: false))
        ]);
  }

  void function2(String ddrecent, String cat) {
    ddyear = null;
    bool = false;
    auxlist = [];
    if (cat == null) cat = "All";

    DateTime n = DateTime.now();

    auxlist = explist.where((item) {
      if (item['date'] != "") {
        String m = item['month'].toString();
        String d = item['day'].toString();
        String y = item['year'].toString();
        if (m.length == 1) m = "0" + m;
        if (d.length == 1) d = "0" + d;
        if (y.length == 1) y = "000" + y;
        String s = y + "-" + m + '-' + d;
        DateTime t = DateTime.parse(s);

        if (ddrecent == "Last week") {
          if (cat == 'All') return n.difference(t) < Duration(days: 7);
          if (cat == item['cat'])
            return n.difference(t) < Duration(days: 7) && cat == item['cat'];
          else
            return false;
        }
        if (ddrecent == "Last 2 weeks") {
          if (cat == 'All') return n.difference(t) < Duration(days: 14);
          if (cat == item['cat'])
            return n.difference(t) < Duration(days: 14) && cat == item['cat'];
          else
            return false;
        }
        if (ddrecent == "Last month") {
          if (cat == 'All') return n.difference(t) < Duration(days: 30);
          if (cat == item['cat'])
            return n.difference(t) < Duration(days: 30) && cat == item['cat'];
          else
            return false;
        }
        if (ddrecent == "Last 4 months") {
          if (cat == 'All') return n.difference(t) < Duration(days: 120);
          if (cat == item['cat'])
            return n.difference(t) < Duration(days: 120) && cat == item['cat'];
          else
            return false;
        }
        if (ddrecent == "Last year") {
          if (cat == 'All') return n.difference(t) < Duration(days: 365);
          if (cat == item['cat'])
            return n.difference(t) < Duration(days: 365) && cat == item['cat'];
          else
            return false;
        }
      } else
        return false;
    }).toList();
  }

  @override
  void didChangeDependencies() {
    if (isnit) {
      print("is init");
      explist = Provider.of<ExpP>(context, listen: false).getList().map((el) {
        return {
          'id': el.id,
          'amount': el.amount,
          'day': el.date != "" ? el.date.split("/")[0] : 0,
          'month': el.date != "" ? el.date.split("/")[1] : 0,
          'year': el.date != "" ? el.date.split("/")[2] : 0,
          'cat': el.description,
        };
      }).toList();
      auxlist = explist;
    }

    print("not init");

    isnit = false;
    super.didChangeDependencies();
  }

  Widget mBody() {
    return explist.isEmpty?Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.indigo.withOpacity(0.4),
          Colors.deepPurple.withOpacity(0.4),
          Colors.purple.withOpacity(0.3),
          Colors.pink.withOpacity(0.3),
          Colors.red.withOpacity(0.3),
          Colors.orange.withOpacity(0.3),
        ],
      ),),
      child:Center(child: Text("Please insert data")))
      
      : Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.indigo.withOpacity(0.4),
          Colors.deepPurple.withOpacity(0.4),
          Colors.purple.withOpacity(0.3),
          Colors.pink.withOpacity(0.3),
          Colors.red.withOpacity(0.3),
          Colors.orange.withOpacity(0.3),
        ],
      ),),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey)),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: DropdownButton<String>(
                        value: ddcat,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String newValue) {
                          setState(() {
                            ddcat = newValue;
                          });
                          bool
                              ? function(ddcat, ddmonth, ddyear)
                              : function2(ddrecent, ddcat);
                        },
                        hint: Text("Select category"),
                        items: <String>[
                          'All',
                          'Others',
                          
                          'Food',
                          'Housekeeping',
                          'Car',
                          'Gasoline',
                          'Taxes',
                          'Electronics',
                          'Pet',
                          'Clothes',
                          'Electricity bill',
                          'Gas',
                          'Entertainment'

                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            child: bool
                ? shownChart(auxlist, ddcat, ddmonth, ddyear)
                : shownChart2(auxlist, ddrecent),
          ),
          // RaisedButton(
          //   child: Text("Show Chart"),
          //   onPressed: () {
          //     function(ddcat, ddmonth, ddyear);
          //   },
          // ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey)),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: DropdownButton<String>(
                    value: ddyear,
                    icon: Icon(Icons.arrow_drop_up),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        ddyear = newValue;
                        function(ddcat, ddmonth, ddyear);
                      });
                    },
                    hint: Text("Select year"),
                    items: <String>['All', '2019', '2018', '2017']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey)),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: DropdownButton<String>(
                    value: ddrecent,
                    icon: Icon(Icons.arrow_drop_up),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        ddrecent = newValue;
                        function2(ddrecent, ddcat);
                      });
                    },
                    hint: Text("Period"),
                    items: <String>[
                      'Last week',
                      'Last 2 weeks',
                      'Last month',
                      'Last 4 months',
                      'Last year'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var or = MediaQuery.of(context).orientation == Orientation.landscape;
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("Charts"),
          
        ),
        body: or ? SingleChildScrollView(child: mBody()) : mBody(),
      ),
    );
  }
}

class Cartesian {
  Cartesian(this.x, this.y);

  String x;
  double y;
}
