import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/todo.dart';

class ManageTodoDialog extends StatefulWidget {
  final Todo? todo;

  const ManageTodoDialog({
    super.key,
    this.todo,
  });

  @override
  State<ManageTodoDialog> createState() => _ManageTodoDialogState();
}

class _ManageTodoDialogState extends State<ManageTodoDialog> {
  final formKey = GlobalKey<FormState>();
  String title = "";
  String date = DateTime.now().toString();
  bool isDone = false;

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      title = widget.todo!.title;
      date = widget.todo!.date;
      isDone = widget.todo!.isDone;
    }
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Navigator.pop(context, {
        "title": title,
        "date": date,
        "isDone": isDone,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        widget.todo != null ? "Edit todo" : "Add todo",
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Todo title",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Enter todo title";
                }

                return null;
              },
              onSaved: (newValue) {
                title = newValue!;
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  DateFormat('dd-MMMM, yyyy').format(DateTime.parse(date)),
                ),
                TextButton(
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: DateTime.parse(date),
                            currentDate: DateTime.now())
                        .then(
                      (value) => setState(() {
                        date = value.toString();
                      }),
                    );
                  },
                  child: const Text('Set date'),
                ),
              ],
            ),
            Visibility(
              visible: widget.todo == null ? false : true,
              child: SwitchListTile(
                title: const Text('Completed?'),
                value: isDone,
                onChanged: (value) {
                  setState(() {
                    isDone = value;
                  });
                },
              ),
            ),
            // TextFormField(
            //   initialValue: date.toString(),
            //   keyboardType: TextInputType.number,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     labelText: "Mahsulot narxini",
            //   ),
            //   validator: (value) {
            //     if (value == null || value.trim().isEmpty) {
            //       return "Iltimos mahsulot narxini kiriting";
            //     }
            //
            //     return null;
            //   },
            //   onSaved: (newValue) {
            //     date = double.parse(newValue!);
            //   },
            // ),
            const SizedBox(height: 10),
            // TextFormField(
            //   initialValue: isDone.toString(),
            //   keyboardType: TextInputType.number,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     labelText: "Mahsulot sonini",
            //   ),
            //   validator: (value) {
            //     if (value == null || value.trim().isEmpty) {
            //       return "Iltimos mahsulot sonini kiriting";
            //     }
            //
            //     return null;
            //   },
            //   onSaved: (newValue) {
            //     isDone = int.parse(newValue!);
            //   },
            // ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: submit,
          child: const Text("Save"),
        ),
      ],
    );
  }
}
