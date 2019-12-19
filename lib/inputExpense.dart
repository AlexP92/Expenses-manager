import 'package:flutter/material.dart';
import './expenseprov.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'imagepicker.dart';
import 'package:intl/intl.dart';

class InputExpense extends StatefulWidget {
  static const routeName = "/input";

  @override
  _InputExpenseState createState() => _InputExpenseState();
}

class _InputExpenseState extends State<InputExpense> {
  Exp expense = Exp(
      title: "",
      amount: 0,
      description: "",
      date: '',
      id: DateTime.now().toString(),
      image: "");

  var initValues = {
    'title': "",
    'amount': "0",
    'description': "",
    'date': '',
    'image': "",
  };

  var isInit = true;

  final _form = GlobalKey<FormState>();

  File _pickedImage;

  void _selectImage(File pickedImage) {
    if (pickedImage != null) {
      _pickedImage = pickedImage;
      expense.image = _pickedImage.path;
    } else {
      _pickedImage = null;
      expense.image = null;
    }
  }

  String inputdate = '';

  void _editExpense() async {
    print(expense.image);
    expense.date = inputdate;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();

    Provider.of<ExpP>(context, listen: false).editExpense(expense);
    Navigator.of(context).pop();
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if (expense.description == "") expense.description = "Others";

    _form.currentState.save();

    Provider.of<ExpP>(context, listen: false).addExpense(expense);
    Navigator.of(context).pop();
  }

  void _deleteForm() async {
    if (expense.image != null || expense.image != "") {
      File(expense.image).delete();
      imageCache.clear();
    }

    Provider.of<ExpP>(context, listen: false).deleteExpense(expense);
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2100));
    if (picked != null) {
      setState(() {
        inputdate = DateFormat('d/M/yyyy').format(picked);
        expense.date = inputdate;
      });
    }
  }

  String ddaux;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final editExp = ModalRoute.of(context).settings.arguments as Exp;
      if (editExp != null) {
        isInit = true;

        initValues = {
          'title': editExp.title,
          'amount': editExp.amount.toString(),
          'description': editExp.description,
          'date': editExp.date,
          'image': editExp.image,
        };
        if (initValues['date'] != null) {
          inputdate = initValues['date'];
        }

        if (initValues['description'] != "") {
          expense.description = editExp.description;
        }
        expense.image = editExp.image;
        expense.id = editExp.id;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Exp editExp = ModalRoute.of(context).settings.arguments as Exp;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          title:
              editExp != null ? Text('Edit expense') : Text('Add an expense'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: initValues['title'],
                          decoration: InputDecoration(labelText: "Title"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Pls provide a title";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            expense = Exp(
                                title: value,
                                description: expense.description,
                                id: expense.id,
                                date: expense.date,
                                amount: expense.amount,
                                image: expense.image);
                          },
                        ),
                        TextFormField(
                          initialValue: initValues['amount'] == "0"
                              ? ""
                              : initValues['amount'],
                          decoration: InputDecoration(labelText: "Amount"),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Pls provide a value";
                            }
                            if (double.parse(value) <= 0) {
                              return "Pls provide a positive value";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            expense = Exp(
                                title: expense.title,
                                description: expense.description,
                                id: expense.id,
                                date: expense.date,
                                amount: double.parse(value),
                                image: expense.image);
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("Category"),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.grey)),
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: DropdownButton<String>(
                                  value: expense.description != ""
                                      ? expense.description
                                      : "Others",
                                  icon: Icon(Icons.arrow_upward),
                                  iconSize: 24,
                                  elevation: 16,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      expense.description = newValue;
                                    });
                                  },
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  //
                                  child: inputdate == ""
                                      ? Text("No date chosen")
                                      : Text(inputdate)),
                              FlatButton.icon(
                                icon: Icon(
                                  Icons.calendar_today,
                                ),
                                label: Text("Select date"),
                                textColor: Theme.of(context).primaryColor,
                                onPressed: _selectDate,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ImageInput(_selectImage, expense.image),
                        SizedBox(
                          height: 20,
                        ),
                        editExp != null
                            ? FlatButton.icon(
                                icon: Icon(Icons.delete),
                                label: Text("Delete expense"),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            backgroundColor: Colors.amber[100],
                                            content: Text(
                                                "This expense will be deleted. Are you sure?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("No",style: TextStyle(color: Colors.indigo)),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              FlatButton(
                                                child: Text("Yes",style: TextStyle(color: Colors.indigo),),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _deleteForm();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ));
                                },
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton.icon(
              icon: editExp != null?Icon(Icons.edit):Icon(Icons.add),
              label:
                  editExp != null ? Text('Save Changes') : Text('Add Expense'),
              onPressed: () {
                if (editExp != null) {
                  _editExpense();
                } else {
                  _saveForm();
                }
              },
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
