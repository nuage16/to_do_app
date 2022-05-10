import 'package:flutter/material.dart';
import 'package:to_do_app/provider/date_provider.dart';
import 'package:to_do_app/utils/time_utils.dart';
import 'package:provider/provider.dart';

class DateList extends StatefulWidget {
  const DateList({Key? key}) : super(key: key);

  @override
  State<DateList> createState() => _DateListState();
}

class _DateListState extends State<DateList> {
  DateTime? currDate;

  //Get the List of Dates
  List<dynamic> allList = ['All'];

  @override
  Widget build(BuildContext context) {
    final _dateProvider = Provider.of<DateProvider>(context);

    //Generate list of dates seven days from today
    for (int i = 0; i < 7; i++) {
      allList.add(TimeUtils.getWeekDate(DateTime.now(), i));
    }

    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: ((context, index) {
          if (index > 0) {
            return getCustomCard(
                index: index,
                title: allList[index].day.toString(),
                subtitle: TimeUtils.getMonth(allList[index]),
                updateState: (i) {
                  setState(() {
                    currDate = allList[i];
                    _dateProvider.setDateFilter(currDate!);
                  });
                });
          }

          return getCustomCard(
              index: index,
              title: allList[index],
              updateState: (i) {
                if (currDate != null) {
                  setState(() {
                    currDate = null;
                    _dateProvider.setDateFilter(currDate);
                  });
                }
              });
        }));
  }

  Widget getCustomCard(
      {required int index,
      required String title,
      String? subtitle,
      required Function(int i) updateState}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(8)),
        color:

            ///If date doesn't match, background color is transparent/scaffoldColor
            currDate == null && index == 0
                ? null
                : currDate == allList[index]
                    ? null
                    : Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () {
            updateState(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: currDate == null && index == 0
                      ? Theme.of(context).textTheme.headline6
                      : currDate == allList[index]
                          ? Theme.of(context).textTheme.headline6
                          : Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: currDate == TimeUtils.getDate(allList[index])
                        ? Theme.of(context).textTheme.bodyText2
                        : Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
