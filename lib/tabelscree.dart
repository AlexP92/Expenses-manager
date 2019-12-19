import 'package:flutter/material.dart';
import 'expenseprov.dart';
import 'package:provider/provider.dart';

class TabelScreen extends StatefulWidget {
  static const routeName = "/tablescreen";
  @override
  _TabelScreenState createState() => _TabelScreenState();
}

class _TabelScreenState extends State<TabelScreen> {
  var isInit = true;
  var stitle = true;
  var samount = true;
  var sdate = true;
  var scat = true;

  List<Map<String, dynamic>> explist;

  Widget drw() {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(height: MediaQuery.of(context).size.height-24,
          decoration: BoxDecoration(gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.indigo.withOpacity(0.8),
        Colors.deepPurple.withOpacity(0.8),
        Colors.purple.withOpacity(0.7),
        Colors.pink.withOpacity(0.7),
        Colors.red.withOpacity(0.7),
        Colors.orange.withOpacity(0.7),
      ],
    )),
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 6,
              ),
              FlatButton.icon(
                icon: Icon(Icons.arrow_back),
                label: Text("Go Back"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Text("Select Columns"),
                    ),
                    Row(
                      children: <Widget>[
                        Text("Show title"),
                        Switch(
                          value: stitle,
                          onChanged: onChangetitle,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Show date"),
                        Switch(
                          value: sdate,
                          onChanged: onChangedate,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Show amount"),
                        Switch(
                          value: samount,
                          onChanged: onChangeamount,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Show category"),
                        Switch(
                          value: scat,
                          onChanged: onChangecat,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (isInit)
      explist = Provider.of<ExpP>(context, listen: false).getList().map((el) {
        String d, m, y;
        if (el.date != "") {
          if (el.date.split("/")[0].length == 1)
            d = "0" + el.date.split("/")[0];
          else
            d = el.date.split("/")[0];
        } else
          d = "00";
        if (el.date != "") {
          if (el.date.split("/")[1].length == 1)
            m = "0" + el.date.split("/")[1];
          else
            m = el.date.split("/")[1];
        } else
          m = "00";
        if (el.date != "") {
          y = el.date.split("/")[2];
        } else
          y = "0000";

        return {
          'title': el.title,
          'id': el.id,
          'amount': el.amount,
          'date': el.date,
          'cat': el.description,
          'datetime': y + '-' + m + '-' + d,
        };
      }).toList();
    isInit = false;
    super.didChangeDependencies();
  }

  void onChangetitle(bool value) {
    setState(() {
      stitle = !stitle;
    });
  }

  void onChangeamount(bool value) {
    setState(() {
      samount = !samount;
    });
  }

  void onChangedate(bool value) {
    setState(() {
      sdate = !sdate;
    });
  }

  void onChangecat(bool value) {
    setState(() {
      scat = !scat;
    });
  }


  var sorttitle=true;
  var sortamount=true;
  var sortcat=true;
  var sortdate=true;
  

  @override
  Widget build(BuildContext context) {
    
    var appBar = AppBar(
      title: Text("Tables"),
    );
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: stitle == false &&
                samount == false &&
                sdate == false &&
                scat == false
            ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.indigo.withOpacity(0.4),
        Colors.deepPurple.withOpacity(0.4),
        Colors.purple.withOpacity(0.3),
        Colors.pink.withOpacity(0.3),
        Colors.red.withOpacity(0.3),
        Colors.orange.withOpacity(0.3),
      ],
    )),
                child: Center(child: Text("Pls select columns")),
              )
            : Container(
                       decoration: BoxDecoration(gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.indigo.withOpacity(0.4),
        Colors.deepPurple.withOpacity(0.4),
        Colors.purple.withOpacity(0.3),
        Colors.pink.withOpacity(0.3),
        Colors.red.withOpacity(0.3),
        Colors.orange.withOpacity(0.3),
      ],
    )),
                      child: 
            ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SingleChildScrollView(
                    child: DataTable(
                       
                        columns: <DataColumn>[
                          if (stitle)
                            DataColumn(label: Text("Title"), onSort: (i,b){
                              setState(() {
                                
                                if(sorttitle)
                               explist.sort((a,b)=>a['title'].compareTo(b['title']));
                               else
                               explist.sort((a,b)=>b['title'].compareTo(a['title']));
                               sorttitle=!sorttitle;
                              });
                            }),
                          if (samount)
                            DataColumn(label: Text("Amount"),  onSort: (i,b){
                              setState(() {
                                
                                if(sorttitle)
                               explist.sort((a,b){
                                
                                 
                                 return (a['amount']-b['amount']).floor();
                               });
                               else
                               explist.sort((a,b){
                               
                                 
                                 return (b['amount']-a['amount']).floor();
                               });
                               sorttitle=!sorttitle;
                              });
                            }),
                          if (scat)
                            DataColumn(label: Text("Category"), onSort:  (i,b){
                              setState(() {
                                
                                if(sortcat)
                               explist.sort((a,b)=>a['cat'].compareTo(b['cat']));
                               else
                               explist.sort((a,b)=>b['cat'].compareTo(a['cat']));
                               sortcat=!sortcat;
                              });
                            }),
                          if (sdate)
                            DataColumn(label: Text("Date"),  onSort: (i,b){
                              setState(() {
                                
                                if(sorttitle)
                               explist.sort((a,b)=>DateTime.parse(a['datetime']).isBefore(DateTime.parse(b['datetime']))?1:0);
                               else
                               explist.sort((a,b)=>DateTime.parse(b['datetime']).isBefore(DateTime.parse(a['datetime']))?1:0);
                               sorttitle=!sorttitle;
                              });
                            }),
                        ],
                        rows: stitle == false &&
                                samount == false &&
                                sdate == false &&
                                scat == false
                            ? <DataRow>[]
                            : <DataRow>[
                                ...explist.map(
                                  (item) => DataRow(
                                    cells: <DataCell>[
                                      if (stitle) DataCell(Text(item['title'])),
                                      if (samount)
                                        DataCell(Text(item['amount'].toString())),
                                      if (scat) DataCell(Text(item['cat'])),
                                      if (sdate) DataCell(Text(item['date'])),
                                    ],
                                  ),
                                ),
                              ],
                      ),
                    
                  ),
                ],
              ),),
        drawer: drw(),
      ),
    );
  }
}
