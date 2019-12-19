import 'package:flutter/material.dart';
import 'chartscreen.dart';
import 'tabelscree.dart';

class DrawerX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      height: MediaQuery.of(context).size.height-24,
      padding: const EdgeInsets.all(16.0),
      
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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            FlatButton.icon(
              label: Text("Go to Charts"),
              icon: Icon(Icons.insert_chart),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ChartScreen.routeName);
               
              },
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton.icon(
              label: Text("Go to Table"),
              icon: Icon(Icons.table_chart),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(TabelScreen.routeName);
               
              },
            ),
          ],
        ),
      
    );
  }
}