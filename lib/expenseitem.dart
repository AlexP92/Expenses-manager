import 'package:flutter/material.dart';
import 'expenseprov.dart';
import 'dart:io';
import 'inputExpense.dart';
import 'package:page_transition/page_transition.dart';

import 'package:photo_view/photo_view.dart';

class Item extends StatelessWidget {
  final Exp e;

  Item(this.e);

  @override
  Widget build(BuildContext context) {
    Container articleImage(var url) {
      final Image img = Image.file(
        File(url),
        fit: BoxFit.cover,
      );
      try {
        return Container(
          height: 140,
          width: 100,
          color: Colors.white,
          child: url != null && url != ""
              ? InkWell(
                  child: img,
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: PhotoView(
                              imageProvider: FileImage(File(url)),
                              minScale: PhotoViewComputedScale.contained * 1,
                              maxScale: PhotoViewComputedScale.covered * 4,
                            )));
                  },
                )
              : Container(
                  height: 60,
                  width: 40,
                  color: Colors.orange[100],
                  child: Icon(Icons.photo),
                ),
        );
      } catch (Exception) {
        return Container(
          height: 60,
          width: 40,
          color: Colors.orange[100],
          child: Icon(Icons.photo),
        );
      }
    }

    final articleThumbnail = Container(
      alignment: FractionalOffset(0.0, 0.5),
      margin: const EdgeInsets.only(left: 16.0),
      child: Card(
        elevation: 5,
        child: Container(
            child: articleImage(e.image),
            width: 100.0,
            height: 140.0,
            decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: Colors.black45), // border color
            )),
      ),
    );

    final articleCard = Card(
        margin: const EdgeInsets.only(left: 60.0, right: 16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.amber[300].withOpacity(0.8),
                Colors.orange.withOpacity(0.7),
                Colors.indigo.withOpacity(0.7),
                Colors.black54.withOpacity(0.8),
              ],
            ),
            border: Border.all(width: 1, color: Colors.black),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Container(
            margin: const EdgeInsets.only(
                top: 8.0, left: 68.0, right: 4.0, bottom: 8.0),
            constraints: BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: Text(
                      e.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                    color: Colors.black.withOpacity(0.3),
                    width: double.infinity,
                    height: 1.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0)),
                Row(
                  children: <Widget>[
                    Icon(Icons.description, size: 14.0, color: Colors.black45),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        e.description,
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                Container(
                    color: Colors.black.withOpacity(0.3),
                    width: double.infinity,
                    height: 1.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0)),
                Row(
                  children: <Widget>[
                    Icon(Icons.access_time, size: 14.0, color: Colors.black45),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: e.date != ""
                          ? Text(
                              e.date,
                              style: TextStyle(color: Colors.black87),
                            )
                          : Text("No date"),
                    ),
                  ],
                ),
                Container(
                    color: Colors.black.withOpacity(0.3),
                    width: double.infinity,
                    height: 1.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0)),
                Row(
                  children: <Widget>[
                    Icon(Icons.attach_money, size: 14.0, color: Colors.black45),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        e.amount.toString(),
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                Container(
                    color: Colors.black.withOpacity(0.3),
                    width: double.infinity,
                    height: 1.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.mode_edit),
                      label: Text("Edit/Delete"),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(InputExpense.routeName, arguments: e);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));

    return Container(
      height: 202.0,
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            articleCard,
            articleThumbnail,
          ],
        ),
      ),
    );
  }
}
