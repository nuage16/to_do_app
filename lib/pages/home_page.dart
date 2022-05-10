import 'package:flutter/material.dart';
import 'package:to_do_app/components/date_list.dart';
import 'package:to_do_app/components/to_do_list.dart';
import 'package:to_do_app/provider/date_provider.dart';
import 'package:to_do_app/utils/time_utils.dart';
import 'package:to_do_app/components/bottom_modal.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _addController = TextEditingController();
    final _dateProvider = Provider.of<DateProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text('To-Do',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.white)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                TimeUtils.toStringDate(DateTime.now()),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ),
            ),
            const Expanded(
              flex: 1,
              child: DateList(),
            ),
            Expanded(
              flex: 7,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0XFFECECEC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                    )),
                child: const ToDoList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _dateProvider.setModalDate(DateTime.now());

            _addController.text = '';
            getModalSheet(
              context: context,
              controller: _addController,
              add: true,
            );
          },
        ));
  }
}
