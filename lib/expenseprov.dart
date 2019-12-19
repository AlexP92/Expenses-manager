import 'package:flutter/material.dart';
import 'package:expense_v1/dbhelper.dart';

class Exp {
  String id;
  String title;
  String description;
  double amount;
  String date;
  String image;

  Exp({
    @required this.id,
    @required this.title,
    this.description,
    @required this.amount,
    @required this.date,
    this.image,
  });
}

class ExpP with ChangeNotifier {
  List<Exp> _list = [];

  Future<void> addExpense(Exp exp) async {
    DBHelper().insert('exp', {
      'id': exp.id,
      'title': exp.title,
      'description': exp.description,
      'date': exp.date,
      'amount': exp.amount,
      'image': exp.image,
    });
    notifyListeners();
  }

  Future<void> editExpense(Exp exp) async {
    DBHelper().updateExp('exp', {
      'id': exp.id,
      'title': exp.title,
      'description': exp.description,
      'date': exp.date,
      'amount': exp.amount,
      'image': exp.image,
    });
    notifyListeners();
  }

  Future<void> deleteExpense(Exp exp) async {
    DBHelper().deleteExp(
      'exp',
      exp.id,
    );
    notifyListeners();
  }

  List getList() {
    return [..._list];
  }

  Future<void> fetchAndSet() async {
    final datalist = await DBHelper().getData('exp');

    _list = datalist
        .map((item) => Exp(
              id: item['id'],
              title: item['title'],
              description: item['description'],
              amount: item['amount'],
              date: item['date'],
              image: item['image'],
            ))
        .toList();
    _list = _list.reversed.toList();

    notifyListeners();
  }
}
