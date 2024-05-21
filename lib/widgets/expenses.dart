import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import '../model/expense.dart';

class Expenses extends StatefulWidget{
  Expenses({super.key});
  State<Expenses> createState(){
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
  final List<Expense> registeredExpenses = [
    Expense(
      title: 'Chocolate',
      amount: 15.99,
      category: Category.food,
      date: DateTime.now(),

    ),
    Expense(
      title: 'Fkutter',
      amount: 19.79,
      category: Category.leisure,
      date: DateTime.now(),

    ),
    Expense(
      title: 'ticket',
      amount: 11.90,
      category: Category.travel,
      date: DateTime.now(),

    ),
    Expense(
      title: 'Tomotaa',
      amount: 15.99,
      category: Category.work,
      date: DateTime.now(),

    ),
  ];

  void _openAddExpenseOverly(){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(addexpense: addExpense,
        ));
    }

  void addExpense(Expense expense){
    setState(() {
      registeredExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense){
    final indexOfExpense = registeredExpenses.indexOf(expense);
    setState(() {
      registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Expense Deleted'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: (){
            setState(() {
              registeredExpenses.insert(indexOfExpense, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context){
    Widget mainContent = Center(child: Text('No expense add. Try adding some'));

    if(registeredExpenses.isNotEmpty){
      setState(() {
        mainContent = ExpensesList(expenses: registeredExpenses, onRemoveExpense: removeExpense);
      });
    }
    return Scaffold(
      appBar: AppBar(

        title: Text('Expenses'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _openAddExpenseOverly,
               ),
        ],
      ),
      body: Column(
        children: [
          Text('chart'),
          Expanded(child: mainContent),
      ],
    ),
    );
  }
}