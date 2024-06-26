
import 'dart:io';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/expense.dart';
import '../widgets/expenses.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({required this.addexpense, super.key});
  final Function addexpense;
  @override
  State<NewExpense> createState() {
    // TODO: implement createState
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year - 1, now.month, now.day);
    DateTime lastDate = now;

    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: lastDate);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  Category selectedCategory = Category.leisure;

  void dialog(){
    if(Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
        title: Text('Invalid Input'),
        content: Text(
            'Please make sure you have entered a valid title, amount, date'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('Okay'),
          ),
        ],
      ));
    }
    else if(Platform.isAndroid){
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Invalid Input'),
            content: Text(
                'Please make sure you have entered a valid title, amount, date'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Okay'),
              ),
            ],
          ));
    }
  }

  void submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text.trim());
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (amountIsInvalid ||
        _titleController.text.trim().isEmpty ||
        selectedDate == null) {
      //error
     dialog();
      return;
    }

    widget.addexpense(Expense(
        category: selectedCategory,
        title: _titleController.text,
        amount: enteredAmount,
        date: selectedDate!));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    // TODO: implement build
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboard + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration:
                                const InputDecoration(label: Text('Title')),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(label: Text('Title')),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                            value: selectedCategory,
                            items: Category.values
                                .map((category) => DropdownMenuItem(
                                      child: Text(category.name.toUpperCase()),
                                      value: category,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'Choose Date'
                                  : formatter.format(selectedDate!),
                            ),
                            IconButton(
                                onPressed: _presentDatePicker,
                                icon: Icon(Icons.calendar_month)),
                          ],
                        ))
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'Choose Date'
                                  : formatter.format(selectedDate!),
                            ),
                            IconButton(
                                onPressed: _presentDatePicker,
                                icon: Icon(Icons.calendar_month)),
                          ],
                        ))
                      ],
                    ),
                  SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 20,),
                        ElevatedButton(
                            onPressed: submitExpenseData,
                            child: Text('Save Expense')),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                            value: selectedCategory,
                            items: Category.values
                                .map((category) => DropdownMenuItem(
                                      child: Text(category.name.toUpperCase()),
                                      value: category,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: submitExpenseData,
                            child: Text('Save Expense')),
                      ],
                    )
                ],
              )),
        ),
      );
    });
  }
}
