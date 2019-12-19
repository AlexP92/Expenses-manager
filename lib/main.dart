import 'package:flutter/material.dart';
import './inputExpense.dart';
import './drawer.dart';
import 'package:provider/provider.dart';
import 'expenseprov.dart';
import 'expenseitem.dart';
import 'chartscreen.dart';
import 'tabelscree.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ExpP(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme:
            ThemeData(primarySwatch: Colors.deepPurple, accentColor: Colors.amber),
        home: MyHomePage(title: 'Expenses'),
        routes: {
          InputExpense.routeName: (ctx) => InputExpense(),
          ChartScreen.routeName: (ctx) => ChartScreen(),
          TabelScreen.routeName: (ctx) => TabelScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            FlatButton.icon(
              label: Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(InputExpense.routeName),
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<ExpP>(context, listen: false).fetchAndSet(),
          builder: (ctx, snap) => snap.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<ExpP>(
                  child: Container(
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
                        ),
                      ),
                      child: Center(child: Text("Please insert data"))),
                  builder: (ctx, expenses, ch) => expenses.getList().length == 0
                      ? ch
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
                          )),
                          child: ListView.builder(
                            itemCount: expenses.getList().length,
                            itemBuilder: (ctx, i) =>
                                Item(expenses.getList()[i]),
                          ),
                        )),
        ),
        drawer: Drawer(
          child: DrawerX(),
        ),
      ),
    );
  }
}
