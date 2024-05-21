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

    final pickedDate = await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  Category selectedCategory = Category.leisure;

  void submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text.trim());
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if(amountIsInvalid || _titleController.text.trim().isEmpty || selectedDate == null){
      //error
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Text('Invalid Input'),

        content: Text('Please make sure you have entered a valid title, amount, date'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
          ),
        ],
      ));
      return;
    }

    widget.addexpense(Expense(category: selectedCategory, title: _titleController.text, amount: enteredAmount, date: selectedDate!));
    Navigator.pop(context);


}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [

            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Title')
              ),
            ),

            Row(

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

                SizedBox(width: 15,),

                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          selectedDate == null ? 'No Date Selected' : formatter.format(selectedDate!),
                        ),
                        IconButton(onPressed: _presentDatePicker, icon: Icon(Icons.calendar_month)),


                      ],
                    )
                )
              ],
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                DropdownButton(
                    value: selectedCategory,
                    items: Category.values.map((category) => DropdownMenuItem(
                        child: Text(category.name.toUpperCase()),
                        value: category,
                      )
                    ).toList(),
                    onChanged: (value){
                      if(value == null){
                        return;
                      }
                      setState(() {
                        selectedCategory = value;
                      });

                    }),
                Spacer(),

                ElevatedButton(
                    onPressed: (){
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
        ));
  }
}
