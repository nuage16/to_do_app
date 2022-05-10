import 'package:flutter/cupertino.dart';

class DateProvider extends ChangeNotifier {
  ///In this class, we have two dates provided on the widget tree:
  ///filterDate  and modalDate:
  ///We use these two since there is an option to change the dueDate of specific task/to-do item.
  ///If we used only the filterDate, and the user decides to pick a different
  ///dueDate, the list displayed will be affected.
  ///Sample scenario:
  ///When screen is under "All", then the user adds a new to-do item and changes the date.
  ///Since the modalDate only depends on the filterDate, the filterDate should be updated.
  ///But after update, the list will also be filtered with that updated dateFilter.
  ///Since it is under "All", it'll only be able to show items from the updated filterDate.
  DateTime? _filterDate;
  DateTime? _modalDate;

  ///Returned date is used for filtering items on that specific date
  DateTime? get filterDate => _filterDate;

  ///Returned date is used for holding and updating the value on the modal sheet.
  DateTime? get modalDate => _modalDate;

  void setDateFilter(DateTime? newDate) {
    _filterDate = newDate;
    notifyListeners();
  }

  void setModalDate(DateTime? newDate) {
    _modalDate = newDate;
    notifyListeners();
  }
}
