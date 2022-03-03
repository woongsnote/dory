import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dory/main.dart';
import 'package:dory/pages/today/today_take_tile.dart';
import 'package:dory/pages/today/tody_empty_widget.dart';
import 'package:dory/components/dory_constants.dart';
import 'package:dory/components/dory_title.dart';
import 'package:dory/models/medicine.dart';
import 'package:dory/models/medicine_alarm.dart';
import 'package:dory/models/medicine_history.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DoryTitle(title: '오늘 복용할 약은?'),
        const SizedBox(
          height: regularSpace,
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[];

    if (medicines.isEmpty) {
      return const TodayEmpty();
    }

    for (var medicine in medicines) {
      for (var alarm in medicine.alarms) {
        medicineAlarms.add(MedicineAlarm(
          medicine.id,
          medicine.name,
          medicine.imagePath,
          alarm,
          medicine.key,
        ));
      }
    }

    medicineAlarms.sort(
      (a, b) => DateFormat('HH:mm')
          .parse(a.alarmTime)
          .compareTo(DateFormat('HH:mm').parse(b.alarmTime)),
    );
    return Column(children: [
      const Divider(
        height: 1,
        thickness: 1.0,
      ),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: smallSpace),
          itemCount: medicineAlarms.length,
          itemBuilder: (context, index) {
            return _buildListTile(medicineAlarms[index]);
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: regularSpace,
              thickness: 1.0,
            );
          },
        ),
      ),
      // const Divider(
      //   height: 1,
      //   thickness: 1.0,
      // ),
    ]);
  }

  Widget _buildListTile(MedicineAlarm medicineAlarm) {
    return ValueListenableBuilder(
      valueListenable: historyRepository.historyBox.listenable(),
      builder: (context, Box<MedicineHistory> historyBox, _) {
        if (historyBox.values.isEmpty) {
          return BeforeTakeTile(
            medicineAlarm: medicineAlarm,
          );
        }
        final todayTakeHistory = historyBox.values.singleWhere(
          (history) =>
              history.medicineId == medicineAlarm.id &&
              history.medicineKey == medicineAlarm.key &&
              history.alarmTime == medicineAlarm.alarmTime &&
              isToday(history.takeTime, DateTime.now()),
          orElse: () => MedicineHistory(
            medicineId: -1,
            medicineKey: -1,
            alarmTime: '',
            takeTime: DateTime.now(),
            imagePath: null,
            name: '',
          ),
        );

        if (todayTakeHistory.medicineId == -1 &&
            todayTakeHistory.alarmTime == '') {
          return BeforeTakeTile(
            medicineAlarm: medicineAlarm,
          );
        }

        return AfterTakeTile(
          medicineAlarm: medicineAlarm,
          history: todayTakeHistory,
        );
      },
    );
  }
}

bool isToday(DateTime source, DateTime destination) {
  return source.year == destination.year &&
      source.month == destination.month &&
      source.day == destination.day;
}
