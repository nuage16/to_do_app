import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo_item_model.dart';
import 'package:to_do_app/provider/date_provider.dart';
import 'package:to_do_app/provider/todo_provider.dart';
import 'package:to_do_app/utils/time_utils.dart';
import 'package:provider/provider.dart';

getModalSheet(
    {required BuildContext context,
    required TextEditingController controller,
    required bool add,
    ToDoItem? object}) {
  final _formKey = GlobalKey<FormState>();

  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final _toDoProvider = Provider.of<ToDoProvider>(context);
        final _dateProvider = Provider.of<DateProvider>(context);
        DateTime? dueDate;

        ///First, check if the date on the modal sheet is null.
        ///If not null, return that date;
        ///If null, check if filterDate is null;
        ///If not null, return that date
        DateTime date = _dateProvider.modalDate != null
            ? _dateProvider.modalDate!
            : _dateProvider.filterDate != null
                ? _dateProvider.filterDate!
                : DateTime.now();

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.only(top: 8.0, left: 30.0, right: 30.0),
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Type something...',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        dueDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2025));

                        if (dueDate != null) {
                          _dateProvider.setModalDate(dueDate);
                        }
                      },
                      child: Row(
                        children: [
                          Text(TimeUtils.toStringDate(
                              add ? date : object!.dueDate)),
                          const SizedBox(width: 8.0),
                          const Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (add && object == null) {
                              final newItem = ToDoItem(
                                  toDoName: controller.text,
                                  isDone: false,
                                  dueDate: date);

                              _toDoProvider.addToDoItemToDB(newItem);
                            } else {
                              final newItem = ToDoItem(
                                  id: object!.id,
                                  toDoName: controller.text,
                                  isDone: object.isDone,
                                  dueDate: date);

                              _toDoProvider.updateToDoItemFromDB(newItem);
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Done')),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
